package com.songyinglong.hgshop.entity;

import lombok.Data;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Data
public class Order implements Serializable{
    private String orderId;

    private Integer totalPrice;

    private Integer actualPrice;

    private Integer postFee;

    private Integer paymentType;

    private Integer userId;

    private Integer status;

    private Date createTime;

    @Field( type = FieldType.Nested)
    private List<OrderDetail> orderDetails;
}