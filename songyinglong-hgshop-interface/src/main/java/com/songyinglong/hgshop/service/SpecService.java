package com.songyinglong.hgshop.service;

import com.github.pagehelper.PageInfo;
import com.songyinglong.hgshop.entity.Spec;
import com.songyinglong.hgshop.entity.SpecOption;

import java.util.List;

/**
 * @author SongYinglong
 * @date 2020/1/10- 2020/1/10
 */
public interface SpecService {

    /**
     * 根据分类Id查询规格参数
     * @param spec
     * @param pageNum
     * @param pageSize
     * @return
     */
    PageInfo<Spec> specList(Spec spec, Integer pageNum, Integer pageSize);

    /**
     * 删除规格参数功能
     * @param ids
     */
    void deleteSpecByIds(Integer[] ids);

    Spec getSpecById(Integer id);

    /**
     * 添加或者修改规格参数
     * @param spec
     */
    void saveOrUpdateSpec(Spec spec);

    /**
     * 添加或者修改规格参数
     * @param spec
     */
    void saveOrUpdateSpec1(Spec spec);

    /**
     * 查询全部规格参数
     * @return
     */
    List<Spec> selectSpecs();

    /**
     *  列表展示  分页功能 （在redis中查询）
     * @param pageNum
     * @param pageSize
     * @return
     */
    PageInfo<Spec> specList(Integer pageNum, Integer pageSize);

    /**
     *根据id查询数据 修改查看回显 (在Redis中查询)
     * @param id
     * @return
     */
    Spec getSpecById1(Integer id);

    /**
     * 根据多个id批量删除数据(在redis中操作)
     * @param ids
     */
    void deleteSpecByIds1(Integer[] ids);

    /**
     *  根据规格参数Id查询参数选项
     * @param specId
     * @return
     */
    List<SpecOption> selectSpecOptionBySpecId(Integer specId);
}
