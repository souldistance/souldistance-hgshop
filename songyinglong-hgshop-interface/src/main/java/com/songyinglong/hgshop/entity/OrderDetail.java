package com.songyinglong.hgshop.entity;

import lombok.*;

import java.io.Serializable;

@Data
public class OrderDetail implements Serializable{
    private Integer id;

    private String orderId;

    private String skuId;

    private Integer num;

    private String title;

    private Integer price;

    private String image;

}