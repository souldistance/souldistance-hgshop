package com.songyinglong.hgshop.entity;



import lombok.Data;

import java.io.Serializable;

/**
 * @author SongYinglong
 * @date 2020/1/12- 2020/1/12
 */
@Data
public class User implements Serializable{

    private Integer uid;

    private String username;

    private String password;

    private String name;

    private String email;

    private String telephone;

    private String birthday;

    private String sex;

    private Integer state;

    private String code;

    private Integer role;
}
