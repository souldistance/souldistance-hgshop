package com.songyinglong.hgshop.mapper;

import com.songyinglong.hgshop.entity.Cart;
import com.songyinglong.hgshop.entity.CartExample;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CartMapper {
    long countByExample(CartExample example);

    int deleteByExample(CartExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(Cart record);

    int insertSelective(Cart record);

    List<Cart> selectByExample(CartExample example);

    Cart selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") Cart record, @Param("example") CartExample example);

    int updateByExample(@Param("record") Cart record, @Param("example") CartExample example);

    int updateByPrimaryKeySelective(Cart record);

    int updateByPrimaryKey(Cart record);

    void insertCart(Cart cart);

    List<Cart> list(int i);

    void updateNum(@Param("id") Integer id, @Param("pnum") Integer pnum);

    void deleteCartItems(Integer[] ids);

    void deleteAll(Integer userId);

    Cart selectCartByKey(@Param("userId") Integer userId, @Param("skuId") Integer skuId);

    List<Cart> preOrder(@Param("userId") Integer userId, @Param("ids") Integer[] ids);

    void deleteCartItemsBySkuIds(@Param("skuIds") Integer[] skuIds, @Param("userId") Integer userId);
}