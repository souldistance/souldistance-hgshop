package com.songyinglong.hgshop.mapper;

import com.songyinglong.hgshop.entity.SkuSpec;
import com.songyinglong.hgshop.entity.SkuSpecExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

/**
 * @author Souldistance
 */
public interface SkuSpecMapper {
    long countByExample(SkuSpecExample example);

    int deleteByExample(SkuSpecExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(SkuSpec record);

    int insertSelective(SkuSpec record);

    List<SkuSpec> selectByExample(SkuSpecExample example);

    SkuSpec selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") SkuSpec record, @Param("example") SkuSpecExample example);

    int updateByExample(@Param("record") SkuSpec record, @Param("example") SkuSpecExample example);

    int updateByPrimaryKeySelective(SkuSpec record);

    int updateByPrimaryKey(SkuSpec record);
}