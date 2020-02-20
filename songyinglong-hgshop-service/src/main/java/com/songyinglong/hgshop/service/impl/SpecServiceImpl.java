package com.songyinglong.hgshop.service.impl;

import com.alibaba.fastjson.JSON;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.songyinglong.hgshop.entity.Spec;
import com.songyinglong.hgshop.entity.SpecOption;
import com.songyinglong.hgshop.entity.SpecOptionExample;
import com.songyinglong.hgshop.mapper.SpecMapper;
import com.songyinglong.hgshop.mapper.SpecOptionMapper;
import com.songyinglong.hgshop.service.SpecService;
import org.apache.dubbo.config.annotation.Service;
import org.springframework.data.redis.core.ListOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.kafka.core.KafkaTemplate;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author SongYinglong
 * @date 2020/1/21- 2020/1/21
 */
@Service
public class SpecServiceImpl implements SpecService {

    @Resource
    private SpecMapper specMapper;

    @Resource
    private SpecOptionMapper specOptionMapper;

    //@Resource
    private KafkaTemplate<String,String> kafkaTemplate;

    @Resource
    private RedisTemplate<String,Spec> specOptionRedisTemplate;
    /**
     * 规格参数查询
     * @param spec
     * @param pageNum
     * @param pageSize
     * @return
     */
    @Override
    public PageInfo<Spec> specList(Spec spec, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Spec> list = specMapper.selectSpecListByCategoryId(spec);
        PageInfo<Spec> pageInfo = new PageInfo<>(list);
        return pageInfo;
    }

    /**
     * 删除规格参数功能
     * @param ids
     */
    @Override
    public void deleteSpecByIds(Integer[] ids) {
        for (Integer id : ids) {
            //根据Id删除规格参数表中的数据
            specMapper.deleteByPrimaryKey(id);
            //删除规格Id删除规格参数选项表单中的数据
            SpecOptionExample specOptionExample = new SpecOptionExample();
            SpecOptionExample.Criteria criteria = specOptionExample.createCriteria();
            criteria.andSpecIdEqualTo(id);
            specOptionMapper.deleteByExample(specOptionExample);
            //根据规格Id删除分类规格参数中间表中的数据
            specMapper.deleteCategorySpecBySpecId(id);
        }
    }

    /**
     * 根据规格参数Id查询
     * @param id
     * @return
     */
    @Override
    public Spec getSpecById(Integer id) {
        return specMapper.selectByPrimaryKey(id);
    }

    /**
     *  添加或者修改规格参数
     * @param spec
     */
    @Override
    public void saveOrUpdateSpec(Spec spec) {
        if (spec.getId() == null) {
            //1.新增
            //1.1.插入hg_spec
            specMapper.insert(spec);
        } else {
            //2.修改
            //2.1.修改hg_spec
            specMapper.updateByPrimaryKey(spec);
            //2.2.删除对应的hg_spec_option所有的记录
            SpecOptionExample specOptionExample = new SpecOptionExample();
            SpecOptionExample.Criteria criteria = specOptionExample.createCriteria();
            criteria.andSpecIdEqualTo(spec.getId());
            specOptionMapper.deleteByExample(specOptionExample);
        }
        //3.批量插入hg_spec_option
        for (SpecOption specOption : spec.getSpecOptions()) {
            if (specOption.getOptionName()!=null && !"".equals(specOption.getOptionName())) {
                specOption.setSpecId(spec.getId());
                specOptionMapper.insert(specOption);
            }
        }
    }

    /**
     *  添加或者修改规格参数
     * @param spec
     */
    @Override
    public void saveOrUpdateSpec1(Spec spec) {
        //通过Kafka发送数据到Kafka消息队列上
        kafkaTemplate.sendDefault("saveOrUpdateSpec", JSON.toJSONString(spec));
    }
    /**
     * 查询全部规格参数
     * @return
     */
    @Override
    public List<Spec> selectSpecs() {
        return specMapper.selectSpecs();
    }

    /**
     * 列表展示  (在redis中查询)
     * @param pageNum
     * @param pageSize
     * @return
     */
    @Override
    public PageInfo<Spec> specList(Integer pageNum, Integer pageSize) {
        ListOperations<String, Spec> stringSpecListOperations = specOptionRedisTemplate.opsForList();
        List<Spec> specs = stringSpecListOperations.range("specOptions", (pageNum - 1) * pageSize, pageNum * pageSize - 1);
        Page<Spec> page = new Page<Spec>(pageNum,pageSize);
        page.setTotal(stringSpecListOperations.size("specOptions"));
        page.addAll(specs);
        return new PageInfo<Spec>(page,5);
    }

    /**
     *根据id查询数据 修改查看回显 (在Redis中查询)
     * @param id
     * @return
     */
    @Override
    public Spec getSpecById1(Integer id) {
        ListOperations<String, Spec> opsForList = specOptionRedisTemplate.opsForList();
        return opsForList.index("specOptions",id);
    }

    /**
     * 根据多个id批量删除数据(在redis中操作)
     * @param ids
     */
    @Override
    public void deleteSpecByIds1(Integer[] ids) {
        //通过Kafka发送数据到Kafka消息队列上
        kafkaTemplate.sendDefault("deleteSpec", JSON.toJSONString(ids));
    }

    /**
     *  根据规格参数Id查询参数选项
     * @param specId
     * @return List<SpecOption>
     */
    @Override
    public List<SpecOption> selectSpecOptionBySpecId(Integer specId) {
        return specOptionMapper.selectBySpecId(specId);
    }
}
