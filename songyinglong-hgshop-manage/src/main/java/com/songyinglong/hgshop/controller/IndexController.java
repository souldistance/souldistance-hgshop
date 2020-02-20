package com.songyinglong.hgshop.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author SongYinglong
 * @date 2020/1/16- 2020/1/16
 */
@RequestMapping("admin")
@Controller
public class IndexController {

    @GetMapping("index")
    public String index(){
        return "index";
    }

    @GetMapping("welcome")
    public String welcome(){
        return "welcome";
    }
}
