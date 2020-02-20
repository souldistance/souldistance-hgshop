package com.songyinglong.hgshop.entity;

import lombok.*;

import java.io.Serializable;
import java.util.List;

@Data
public class Spu implements Serializable{
    private Integer id;

    private String goodsName;

    private String isMarketable;

    private Integer brandId;

    private String caption;

    private Integer categoryId;

    private String smallPic;

    private Category category;

    private Brand brand;

    private List<Sku> skuList;
}