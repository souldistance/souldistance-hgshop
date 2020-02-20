package com.songyinglong.hgshop.mapper;

import com.songyinglong.hgshop.entity.Spec;
import com.songyinglong.hgshop.entity.SpecExample;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface SpecMapper {
    long countByExample(SpecExample example);

    int deleteByExample(SpecExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(Spec record);

    int insertSelective(Spec record);

    List<Spec>  selectByExample(SpecExample example);

    Spec selectByPrimaryKey(@Param("id") Integer id);

    int updateByExampleSelective(@Param("record") Spec record, @Param("example") SpecExample example);

    int updateByExample(@Param("record") Spec record, @Param("example") SpecExample example);

    int updateByPrimaryKeySelective(Spec record);

    int updateByPrimaryKey(Spec record);

    /**
     * 根据分类Id查询该分类下的规格参数
     * @param spec
     * @return
     */
    List<Spec> selectSpecListByCategoryId(Spec spec);


    /**
     * 查询全部规格参数
     * @return
     */
    List<Spec> selectSpecs();

    /**
     * 根据规格参数Id删除分类规格参数中间表中的数据
     * @param id
     */
    void deleteCategorySpecBySpecId(@Param("id") Integer id);

    /**
     *  根据skuId查询所包含的规格参数以及参数选项
     * @param skuId
     * @return
     */
    List<Spec> selectSpecsBySkuId(@Param("skuId") Integer skuId);

    List<Spec> selectSpecBySpuIds(List<Integer> spuIds);
}