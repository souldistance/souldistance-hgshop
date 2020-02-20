package com.songyinglong.hgshop.service.impl;

import com.songyinglong.hgshop.entity.Cart;
import com.songyinglong.hgshop.mapper.CartMapper;
import com.songyinglong.hgshop.service.CartService;
import org.apache.dubbo.config.annotation.Service;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

/**
 * 购物车服务
 * @author coolface
 *
 */
@Service
public class CartServiceImpl implements CartService {

	@Resource
	private CartMapper cartMapper;
	
	/**
	 * 添加购物车
	 */
	@Override
	public void addCart(Cart cart) {
		cart.setCreateTime(new Date());
		cartMapper.insertCart(cart);
	}

	/**
	 * 购物车列表
	 */
	@Override
	public List<Cart> list(Integer userId) {
		return cartMapper.list(userId);
	}

	/**
	 * 修改数量
	 */
	@Override
	public void updateNum(Integer id, Integer pnum) {
		cartMapper.updateNum(id, pnum);
	}

	/**
	 * 删除购物项
	 */
	@Override
	public void deleteCartItems(Integer[] ids) {
		cartMapper.deleteCartItems(ids);
	}

	/**
	 * 清空购物车
	 */
	@Override
	public void clearCart(Integer userId) {
		cartMapper.deleteAll(userId);
	}

	@Override
	public Cart getCartByKey(Integer userId, Integer skuId) {
		return cartMapper.selectCartByKey(userId, skuId);
	}

	@Override
	public List<Cart> preOrder(Integer userId, Integer[] ids) {
		return cartMapper.preOrder(userId, ids);
	}

	@Override
	public void deleteCartItemsBySkuIds(Integer[] skuIds, Integer userId) {
		cartMapper.deleteCartItemsBySkuIds(skuIds, userId);
	}
}
