package com.songyinglong.hgshop.mapper;

import com.songyinglong.hgshop.entity.SpecOption;
import com.songyinglong.hgshop.entity.SpecOptionExample;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface SpecOptionMapper {
    long countByExample(SpecOptionExample example);

    int deleteByExample(SpecOptionExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(SpecOption record);

    int insertSelective(SpecOption record);

    List<SpecOption> selectByExample(SpecOptionExample example);

    /**
     * 根据规格参数Id查询规格选项
     * @param specId
     * @return
     */
    List<SpecOption> selectBySpecId(@Param("specId") Integer specId);

    SpecOption selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") SpecOption record, @Param("example") SpecOptionExample example);

    int updateByExample(@Param("record") SpecOption record, @Param("example") SpecOptionExample example);

    int updateByPrimaryKeySelective(SpecOption record);

    int updateByPrimaryKey(SpecOption record);

    /**
     *   根据skuId在hg_sku_spec中间表中查询所包含的规格参数选项
     * @param skuId
     * @param specId
     * @return
     */
    List<SpecOption> selectBySkuId(@Param("skuId") Integer skuId, @Param("specId") Integer specId);
}