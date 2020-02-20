package com.songyinglong.hgshop.mapper;

import com.songyinglong.hgshop.entity.Brand;
import com.songyinglong.hgshop.entity.BrandExample;
import com.songyinglong.hgshop.entity.Category;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface BrandMapper {
    long countByExample(BrandExample example);

    int deleteByExample(BrandExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(Brand record);

    int insertSelective(Brand record);

    List<Brand> selectByExample(BrandExample example);

    Brand selectByPrimaryKey(@Param("id")Integer id);

    int updateByExampleSelective(@Param("record") Brand record, @Param("example") BrandExample example);

    int updateByExample(@Param("record") Brand record, @Param("example") BrandExample example);

    int updateByPrimaryKeySelective(Brand record);

    int updateByPrimaryKey(Brand record);

    void selectByExample();

    /**
     *  根据品牌Id查询所属的分类
     * @param brandId
     * @return
     */
    List<Category> selectCategoriesByBrandId(@Param("brandId")Integer brandId);



    /**
     * 查询全部品牌
     * @return
     */
    List<Brand> selectBrands();

    List<Brand> selectBrandByIds(List<Long> brandIds);
}