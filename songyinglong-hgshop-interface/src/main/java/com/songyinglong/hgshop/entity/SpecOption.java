package com.songyinglong.hgshop.entity;

import lombok.*;

import java.io.Serializable;

/**
 * @author Souldistance
 */
@Data
public class SpecOption implements Serializable{
    private Integer id;

    private String optionName;

    private Integer specId;

    private Integer orders;

}