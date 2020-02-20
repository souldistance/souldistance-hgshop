package com.songyinglong.hgshop.service;

import com.songyinglong.hgshop.entity.Cart;

import java.util.List;

public interface CartService {

	void addCart(Cart cart);
	
	List<Cart> list(Integer userId);

	void updateNum(Integer id, Integer pnum);
	
	void deleteCartItems(Integer[] ids);
	
	void clearCart(Integer userId);

	Cart getCartByKey(Integer userId, Integer skuId);

	List<Cart> preOrder(Integer userId, Integer[] ids);

    void deleteCartItemsBySkuIds(Integer[] integers, Integer userId);
}
