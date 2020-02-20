package com.songyinglong.hgshop.service;

import com.github.pagehelper.PageInfo;
import com.songyinglong.hgshop.entity.Order;

import java.util.Map;

public interface OrderService {

	/**
	 * 生成订单
	 * @param order
	 * @return
	 */
	String createOrder(Order order);

	/**
	 * 订单详情
	 * @param orderId
	 * @return
	 */
	Order getOrderById(String orderId);


	/**
	 *  我的订单
	 * @param userId
	 * @param keyword
	 * @param pageNum
	 * @param pageSize
	 * @return
	 */
	PageInfo<Order> orderList(Integer userId, String keyword, Integer pageNum, Integer pageSize);
	Map<String, Object> search(String keyword, Integer pageNum, Integer pageSize, Map<String, String> filter);
	void saveESOrder(Order order);
}
