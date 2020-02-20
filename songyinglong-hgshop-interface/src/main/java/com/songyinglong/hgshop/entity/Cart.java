package com.songyinglong.hgshop.entity;

import lombok.*;

import java.io.Serializable;
import java.util.Date;


/**
 * @author Souldistance
 */
@Data
public class Cart  implements Serializable{
    private Integer id;

    private Integer uid;

    private Integer skuId;

    private Integer pnum;

    private Date createTime;

    private Date updateTime;


    private String image;
    private String title;
    private Integer price;
    private Integer subPrice;

}