package com.songyinglong.hgshop.intercepter;

import com.songyinglong.hgshop.entity.User;
import com.songyinglong.hgshop.service.UserService;
import org.apache.dubbo.config.annotation.Reference;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.net.URLDecoder;

/**
 * @author 作者:SongYinglong
 * @version 创建时间：2020年1月10日 下午2:07:42
 * 类功能说明
 */
public class AdminInterceptor extends HandlerInterceptorAdapter {

    @Reference
    private UserService userService;
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object admin = session.getAttribute("admin");
            if (admin != null) {
                return true;
            }
        }
        String username="";
        String password="";
        Cookie[] cookies = request.getCookies();
        if(cookies!=null  && cookies.length>0){
            for (Cookie cookie : cookies) {
                if(cookie.getName().equals("username")){
                    username=URLDecoder.decode(cookie.getValue(),"utf-8");
                }
                if(cookie.getName().equals("password")){
                    password=URLDecoder.decode(cookie.getValue(),"utf-8");
                }
            }
        }
        if(username!="" && password!=""){
            User user = new User();
            user.setUsername(username);
            user.setPassword(password);
            User u = userService.login(user);
            request.getSession().setAttribute("admin",u);
            return true;
        }
        request.setAttribute("message", "请先登录!");
        request.getRequestDispatcher("/WEB-INF/view/passport/login.jsp").forward(request, response);
        return false;
    }
}
