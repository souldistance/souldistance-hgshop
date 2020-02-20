package com.songyinglong.hgshop.mapper;

import com.songyinglong.hgshop.entity.Brand;
import com.songyinglong.hgshop.entity.Category;
import com.songyinglong.hgshop.entity.CategoryExample;
import com.songyinglong.hgshop.entity.Spec;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CategoryMapper {
    long countByExample(CategoryExample example);

    int deleteByExample(CategoryExample example);

    int deleteByPrimaryKey(@Param("id") Integer id);

    int insert(Category record);

    int insertSelective(Category record);

    List<Category> selectByExample(Category category);

    Category selectByPrimaryKey(@Param("id") Integer id);

    int updateByExampleSelective(@Param("record") Category record, @Param("example") CategoryExample example);

    int updateByExample(@Param("record") Category record, @Param("example") CategoryExample example);

    int updateByPrimaryKeySelective(Category record);

    int updateByPrimaryKey(Category record);

    List<Category> selectAllCategories();

    Integer getChildCategoryCount(@Param("id") Integer id);

    Integer selectParentId(@Param("id") Integer id);

    /**
     *  添加中间表信息
     * @param brandId
     * @param categoryId
     * @return
     */
    int insertBrandCategory(@Param("brandId") Integer brandId, @Param("categoryId") Integer categoryId);

    /**
     * 插入到hg_category_spec
     * @param category
     * @param spec
     * @return
     */
    int insertCategorySpec(@Param("category") Category category, @Param("spec") Spec spec);

    /**
     *  根据分类Id删除中间表数据
     * @param categoryId
     * @return
     */
    int deleteBrandCategory(@Param("categoryId") Integer categoryId);

    /**
     * 根据分类Id删除与分类的中间表中的数据
     * @param categoryId
     * @return
     */
    int deleteCategorySpecByCategoryId(@Param("categoryId") Integer categoryId);

    /**
     *根据分类Id 在分类品牌中间表中查询
     * @param categoryId
     * @return
     */
    List<Brand> selectCategoryBrandByCategoryId(@Param("categoryId") Integer categoryId);

    /**
     *根据分类Id 在分类规格参数中间表中查询
     * @param categoryId
     * @return
     */
    List<Spec> selectCategorySpecByCategoryId(@Param("categoryId") Integer categoryId);

    /**
     *  sku添加或修改时 查询该分类下的规格参数 及 spu
     * @param id
     * @return
     */
    Category selectSpecsAndSpusByCatrgory(@Param("id") Integer id);

    /**
     *  通过分类Id获取子分类Id
     * @param categoryId
     * @return
     */
    List<Integer> getChildsIdByCategoryId(@Param("categoryId") Integer categoryId);

    String selectCategoryNamesByThreeCategoryId(Integer categoryId);

    List<Category> selectCategoryByIds(List<Long> categoryIds);
}