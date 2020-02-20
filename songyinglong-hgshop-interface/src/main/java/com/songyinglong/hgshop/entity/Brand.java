package com.songyinglong.hgshop.entity;

import lombok.*;

import java.io.Serializable;
import java.util.List;

/**
 * @author Souldistance
 */
@Data
public class Brand implements Serializable{

    private Integer id;

    private String name;

    private String firstChar;

    private Boolean deletedFlag;

    private List<Category> categories;

}