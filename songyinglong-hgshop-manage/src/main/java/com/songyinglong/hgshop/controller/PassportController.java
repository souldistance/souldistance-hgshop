package com.songyinglong.hgshop.controller;

import com.songyinglong.common.utils.StringUtil;
import com.songyinglong.hgshop.entity.User;
import com.songyinglong.hgshop.exception.HgshopAjaxException;
import com.songyinglong.hgshop.exception.HgshopException;
import com.songyinglong.hgshop.service.UserService;
import com.songyinglong.hgshop.util.Result;
import com.songyinglong.hgshop.util.ResultUtil;
import org.apache.dubbo.config.annotation.Reference;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.net.URLEncoder;

/**
 * @author SongYinglong
 * @date 2020/1/10- 2020/1/10
 */
@Controller
public class PassportController {

    @Reference
    private UserService userService;

    @GetMapping("regist")
    public String regist() {
        System.out.println(111);
        return "/passport/regist";
    }

    @GetMapping({"", "/", "login"})
    public String login(HttpServletRequest request, Model model) {
        return "passport/login";
    }

    /**
     * @param user
     * @param model
     * @param redirectAttributes
     * @return
     * @Title: regist
     * @Description: 注册功能!
     * @return: String
     */
    @PostMapping("regist")
    public String regist(User user, Model model, RedirectAttributes redirectAttributes) {
        userService.insertSelective(user);
        redirectAttributes.addFlashAttribute("user", user);
        redirectAttributes.addFlashAttribute("message", "恭喜,注册成功!");
        return "redirect:/passport/login";

    }

    @RequestMapping("findUserByName")
    @ResponseBody
    public boolean findUsername(User user) {
        User u = userService.selectByUsername(user);
        if (u != null && StringUtil.hasText(u.getUsername())) {
            return false;
        } else {
            return true;
        }
    }

    /**
     *  登录功能
     * @param user
     * @param model
     * @param session
     * @param response
     * @param remember
     * @return
     * @throws HgshopAjaxException
     * @throws HgshopException
     * @throws Exception
     */
    @PostMapping(value = {"login", "passport/login"})
    @ResponseBody
    public Result login(User user, Model model, HttpSession session, HttpServletResponse response, String remember) throws HgshopAjaxException, HgshopException, Exception {
        User u = userService.login(user);
        if (remember != null && remember.equals("remember")) {
            Cookie username = new Cookie("username", URLEncoder.encode(user.getUsername(), "utf-8"));
            Cookie password = new Cookie("password", URLEncoder.encode(user.getPassword(), "utf-8"));
            username.setMaxAge(3306 * 24 * 10);
            username.setPath("/");
            password.setPath("/");
            password.setMaxAge(3306 * 24 * 10);
            response.addCookie(username);
            response.addCookie(password);
        }
        if (u.getRole() == 1) {
            session.setAttribute("admin", u);
        } else {
            session.setAttribute("user", u);
        }
        return ResultUtil.success();
    }

    /**
     * @param request
     * @return
     * @Title: logout
     * @Description: 注销
     * @return: String
     */
    @GetMapping("logout")
    public String logout(HttpServletRequest request) {
        // false: 如果requst中没有session则不创建session
        HttpSession session = request.getSession(false);
        if (null != session) {
            session.invalidate();
        }
        return "redirect:/login";
    }
}
