package com.songyinglong.hgshop.entity;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

import java.io.Serializable;
import java.util.List;

/**
 * @author Souldistance
 */
@Data
public class Category implements Serializable{
    private Integer id;

    /**
     * 父分类 id
     */
    private Integer parentId;

    private Integer level;

    @JsonProperty("text")
    private String name;

    /**
     * 一个分类下面可以有多个品牌
     */
    private List<Brand> brands;

    /**
     *一个分类有多个规格参数
     */
    private List<Spec> specs;

    /**
     *  一个分类有多个spu
     */
    private List<Spu> spus;
    /**
     * 子分类列表
     */
    @JsonProperty("nodes")
    private List<Category> childs;

    /**
     *父分类名称
     */
    private String parentName;

    /**
     * 用于在使用treeview时,控制一级二级不能选中 true表示可以选中
     */
    private boolean selectable = true;
}