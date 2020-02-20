package com.songyinglong.hgshop.entity;

import lombok.*;

import java.io.Serializable;
import java.util.List;

/**
 * @author Souldistance
 */
@Data
public class Spec implements Serializable{
    private Integer id;

    private String specName;

    private Integer categoryId;


    /**
     * 规格参数选项集合
     */
    private List<SpecOption> specOptions;


}