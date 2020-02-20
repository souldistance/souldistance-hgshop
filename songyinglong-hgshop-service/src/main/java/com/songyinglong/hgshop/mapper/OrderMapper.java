package com.songyinglong.hgshop.mapper;

import com.songyinglong.hgshop.entity.Order;
import com.songyinglong.hgshop.entity.OrderDetail;
import com.songyinglong.hgshop.entity.OrderExample;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface OrderMapper {
    long countByExample(OrderExample example);

    int deleteByExample(OrderExample example);

    int deleteByPrimaryKey(String orderId);

    int insert(Order record);

    int insertSelective(Order record);

    List<Order> selectByExample(OrderExample example);

    Order selectByPrimaryKey(String orderId);

    int updateByExampleSelective(@Param("record") Order record, @Param("example") OrderExample example);

    int updateByExample(@Param("record") Order record, @Param("example") OrderExample example);

    int updateByPrimaryKeySelective(Order record);

    int updateByPrimaryKey(Order record);




    void insertOrder(Order order);

    void insertOrderDetail(OrderDetail orderDetail);

    Order selectOrderById(String orderId);

    List<Order> selectOrderList(Integer userId);

    List<OrderDetail> selectOrderDetailListByOrderId(String orderId);

    List<Order> selectOrderListBySearch(@Param("keyword")String keyword, @Param("userId")Integer userId);
}