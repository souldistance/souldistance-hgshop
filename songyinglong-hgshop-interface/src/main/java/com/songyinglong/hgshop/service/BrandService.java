package com.songyinglong.hgshop.service;

import com.github.pagehelper.PageInfo;
import com.songyinglong.hgshop.entity.Brand;

import java.util.List;


/**
 * @author SongYinglong
 * @date 2020/1/16- 2020/1/16
 */
public interface BrandService {

    /**
     * 商品列表展示 分页 名称模糊 首字母查询
     * @param brand
     * @param pageNum
     * @param pageSize
     * @return
     */
    PageInfo<Brand> queryBrands(Brand brand, Integer pageNum, Integer pageSize);

    /**
     * 删除品牌功能
     * @param ids
     * @return
     */
    void deleteBrands(Integer[] ids);

    /**
     * 添加品牌功能
     * @param brand
     */
    void brandAdd(Brand brand);

    /**
     *  根据品牌ID查看品牌信息
     * @param id
     * @return
     */
    Brand getBrandById(Integer id);

    /**
     * 根据品牌ID修改品牌信息
     * @param brand
     */
    void editBrand(Brand brand);

    /**
     * 查询全部品牌
     * @return
     */
    List<Brand> selectBrands();
}
