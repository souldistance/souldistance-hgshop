package com.songyinglong.hgshop.entity;

import lombok.*;

import java.io.Serializable;

@Data
public class SkuSpec implements Serializable{
    private Integer id;

    private Integer skuId;

    private Integer specId;

    private Integer specOptionId;

}