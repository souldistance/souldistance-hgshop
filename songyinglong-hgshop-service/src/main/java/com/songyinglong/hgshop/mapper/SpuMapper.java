package com.songyinglong.hgshop.mapper;

import com.songyinglong.hgshop.entity.Brand;
import com.songyinglong.hgshop.entity.Category;
import com.songyinglong.hgshop.entity.Spu;
import com.songyinglong.hgshop.entity.SpuExample;
import com.songyinglong.hgshop.vo.SpuVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface SpuMapper {
    long countByExample(SpuExample example);

    int deleteByExample(SpuExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(Spu record);

    int insertSelective(Spu record);

    List<Spu> selectByExample(SpuExample example);

    Spu selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") Spu record, @Param("example") SpuExample example);

    int updateByExample(@Param("record") Spu record, @Param("example") SpuExample example);

    int updateByPrimaryKeySelective(Spu record);

    int updateByPrimaryKey(Spu record);

    List<Spu> selectSpuByIds(List<Integer> spuIds);

    List<Spu> selectSpuAll();

    List<Integer> selectSpuIdsBySearch(SpuVO spuVO);

    List<Category> selectCategoryBySpuIds(List<Integer> spuIds);

    List<Brand> selectBrandBySpuIds(List<Integer> spuIds);
}