package com.songyinglong.hgshop.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.songyinglong.hgshop.entity.*;
import com.songyinglong.hgshop.mapper.SkuMapper;
import com.songyinglong.hgshop.mapper.SkuSpecMapper;
import com.songyinglong.hgshop.mapper.SpecMapper;
import com.songyinglong.hgshop.mapper.SpuMapper;
import com.songyinglong.hgshop.service.SkuService;
import org.apache.commons.lang3.StringUtils;
import org.apache.dubbo.config.annotation.Service;

import javax.annotation.Resource;
import java.util.*;

/**
 * @author SongYinglong
 * @date 2020/1/29- 2020/1/29
 */
@Service
public class SkuServiceImpl implements SkuService {

    @Resource
    private SkuMapper skuMapper;

    @Resource
    private SkuSpecMapper skuSpecMapper;

    @Resource
    private SpecMapper specMapper;

    @Resource
    private SpuMapper spuMapper;


    /**
     *  sku 列表展示  标题卖点模糊查询
     * @param sku
     * @param pageNum
     * @param pageSize
     * @return
     */
    @Override
    public PageInfo<Sku> skuList(Sku sku, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum,pageSize);
        SkuExample skuExample = new SkuExample();
        SkuExample.Criteria criteria = skuExample.createCriteria();
        if(StringUtils.isNotBlank(sku.getTitle())){
            criteria.andTitleLike("%"+sku.getTitle()+"%");
        }
        if(StringUtils.isNotBlank(sku.getSellPoint())){
            criteria.andSellPointLike("%"+sku.getSellPoint()+"%");
        }
        List<Sku> skus = skuMapper.selectByExample(skuExample);
        return new PageInfo<Sku>(skus);
    }

    /**
     *  删除sku功能
     * @param ids
     */
    @Override
    public void deleteSkuByIds(Integer[] ids) {
        for (Integer id : ids) {
            skuMapper.deleteByPrimaryKey(id);
            //根据skuId删除 hg_sku_spec 中间表数据
            SkuSpecExample skuSpecExample = new SkuSpecExample();
            SkuSpecExample.Criteria criteria = skuSpecExample.createCriteria();
            criteria.andSkuIdEqualTo(id);
            skuSpecMapper.deleteByExample(skuSpecExample);
        }
    }


    /**
     *  根据skuId查询sku数据 (修改前回显,查看详情)
     * @param id
     * @return
     */
    @Override
    public Sku getSkuById(Integer id) {
        return skuMapper.selectByPrimaryKey(id);
    }

    /**
     *  sku添加或修改
     * @param sku
     */
    @Override
    public void saveOrUpdateSku(Sku sku) {
        if(sku.getId()==null){
            sku.setStatus("0");
            sku.setCreateTime(new Date());
            sku.setUpdateTime(new Date());
            skuMapper.insert(sku);
        }else{
            sku.setUpdateTime(new Date());
            skuMapper.updateByPrimaryKeySelective(sku);
            //删除修改前中间表数据
            SkuSpecExample skuSpecExample = new SkuSpecExample();
            SkuSpecExample.Criteria criteria = skuSpecExample.createCriteria();
            criteria.andSkuIdEqualTo(sku.getId());
            skuSpecMapper.deleteByExample(skuSpecExample);
        }
        //向中间表添加数据
        SkuSpec skuSpec = new SkuSpec();
        List<SpecOption> specOptions = sku.getSpecOptions();
        List<Spec> specs = sku.getSpecs();
        System.out.println(specs);
        System.out.println(specOptions);
        if(specOptions!=null && specs!=null){
            for (int i = 0; i < specOptions.size(); i++) {
                skuSpec.setSkuId(sku.getId());
                if(specOptions.get(i).getId()!=null && specs.get(i).getId()!=null){
                    skuSpec.setSpecOptionId(specOptions.get(i).getId());
                    skuSpec.setSpecId(specs.get(i).getId());
                    skuSpecMapper.insert(skuSpec);
                }
            }
        }
    }

    /**
     * 查询最新商品数据
     * @param pageSize
     * @return
     */
    @Override
    public List<Sku> selectNews(int pageSize) {
        return skuMapper.selectNews(pageSize);
    }

    /**
     * 通过skuId查询sku有关信息以及该sku所属的spu中包含的specs
     * @param id
     * @return
     */
    @Override
    public Map<String, Object> getSkuById1(Integer id) {
        Map<String, Object> map = new HashMap<>();

        //1.根据skuId查询sku信息 （关联hg_sku_spec中间表 获得specId optionId 便于数据回显 规格参数选中 ）
        Sku sku = skuMapper.selectSkuById1(id);
        //2.根据spuId查询规格参数列表
        List<Integer> spuIds = new ArrayList<>();
        spuIds.add(sku.getSpuId());
        List<Spec> specs = specMapper.selectSpecBySpuIds(spuIds);

        //3.放到map
        map.put("sku", sku);
        map.put("specs", specs);
        return map;
    }

    /**
     *  通过规格参数选项ids查询
     * @param optionIds
     * @return
     */
    @Override
    public Map<String, Object> getSkuBySpecOptionIds(Integer[] optionIds, Integer spuId) {
        Map<String, Object> map = new HashMap<>();
        //1.获取sku详情
        Sku sku = skuMapper.selectSkuBySpecOptionIds(optionIds,spuId);
        //一般正常情况下sku不为空,即使没有该规格参数的组合,后台录入时,也会添加一份库存和价格为0的记录
        //这样处理是为了详情页展示图片及其他相关信息
        //库存为空，需在页面将规格选项置为禁用状态
        if (sku == null || sku.getStockCount() == 0) {
            if(sku == null){
                sku=new Sku();
                sku.setSpuId(spuId);
            }
            map.put("disable","disable");
        }
        List<SkuSpec> skuSpecList = new ArrayList<>();
        for (int i = 0; i < optionIds.length; i++) {
            SkuSpec skuSpec = new SkuSpec();
            skuSpec.setSpecOptionId(optionIds[i]);
            skuSpecList.add(skuSpec);
        }
        sku.setSkuSpecs(skuSpecList);
        //2.根据spu id获取规格参数及规格参数选项信息(查询该商品中有哪些规格参数)
        List<Integer> spuIds = new ArrayList<>();
        spuIds.add(sku.getSpuId());
        List<Spec> specList = specMapper.selectSpecBySpuIds(spuIds);
        map.put("sku", sku);
        map.put("specs", specList);
        return map;
    }

    @Override
    public Sku getSkuById2(Integer skuId) {
        return skuMapper.selectSkuById2(skuId);
    }
}
