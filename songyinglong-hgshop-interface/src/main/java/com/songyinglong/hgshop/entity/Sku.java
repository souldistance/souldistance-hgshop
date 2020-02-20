package com.songyinglong.hgshop.entity;

import lombok.*;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Data
public class Sku implements Serializable{
    private Integer id;

    private String title;

    private String sellPoint;

    private Integer price;

    private Integer stockCount;

    private String barcode;

    private String image;

    private String status;

    private Date createTime;

    private Date updateTime;

    private BigDecimal costPrice;

    private BigDecimal marketPrice;

    private Integer spuId;

    private Integer categoryId;

    /**
     *  所属的spu
     */
    private Spu spu;

    /**
     *  一个sku对应的多个规格参数
     */
    private List<Spec> specs;

    /**
     *  一个sku对应的多个规格参数选项 （单一个sku中的一个规格参数只能选择一个参数选项）
     */
    private List<SpecOption> specOptions;

    private String cartThumbnail;

    /**
     * sku对应的规格参数列表
     */
    private List<SkuSpec> skuSpecs;
}