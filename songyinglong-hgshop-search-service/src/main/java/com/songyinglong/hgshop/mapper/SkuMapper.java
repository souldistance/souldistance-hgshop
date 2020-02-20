package com.songyinglong.hgshop.mapper;

import com.songyinglong.hgshop.entity.Sku;
import com.songyinglong.hgshop.entity.SkuExample;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface SkuMapper {
    long countByExample(SkuExample example);

    int deleteByExample(SkuExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(Sku record);

    int insertSelective(Sku record);

    List<Sku> selectByExample(SkuExample example);

    Sku selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") Sku record, @Param("example") SkuExample example);

    int updateByExample(@Param("record") Sku record, @Param("example") SkuExample example);

    int updateByPrimaryKeySelective(Sku record);

    int updateByPrimaryKey(Sku record);

    /**
     *  查询最新商品数据
     * @param pageSize
     * @return
     */
    List<Sku> selectNews(@Param("pageSize") int pageSize);

    List<Sku> selectSkusBySpuId(@Param("spuId") Integer spuId);


    /**
     *  根据skuId查询sku信息 （关联hg_sku_spec中间表 获得specId optionId 便于数据回显 规格参数选中 ）
     * @param id
     * @return
     */
    Sku selectSkuById1(@Param("id") Integer id);

    Sku selectSkuBySpecOptionIds(@Param("optionIds") Integer[] optionIds, @Param("spuId") Integer spuId);

    Sku selectSkuById2(Integer skuId);
}