package com.songyinglong.hgshop.controller;

import com.alibaba.fastjson.JSON;
import com.songyinglong.hgshop.entity.Cart;
import com.songyinglong.hgshop.entity.Category;
import com.songyinglong.hgshop.entity.Sku;
import com.songyinglong.hgshop.service.CartService;
import com.songyinglong.hgshop.service.CategoryService;
import com.songyinglong.hgshop.service.SkuService;
import org.apache.dubbo.config.annotation.Reference;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @author SongYinglong
 * @date 2020/2/18- 2020/2/18
 */
@Controller
public class CartDBController2 {

    @Reference
    private CartService cartService;

    @Reference
    private CategoryService categoryService;

    @Reference
    private SkuService skuService;
    /**
     *  加入购物车 （cookie方式）
     * @param request
     * @param skuId
     * @param pnum
     * @return
     */
    @RequestMapping("/addCart2")
    public String addCart2(HttpServletRequest request, Integer skuId, Integer pnum, HttpServletResponse response) {
        Cookie[] cookies = request.getCookies();
        String cartStr="";
        int flag=0;
        if(cookies!=null && cookies.length>0){
            for (Cookie cookie : cookies) {
                //2.如果有，就修改数量
                if (("addCart"+skuId).equalsIgnoreCase(cookie.getName())) {
                    cartStr = cookie.getValue();
                    Cart cart = JSON.parseObject(cartStr, Cart.class);
                    cart.setPnum(cart.getPnum()+pnum);
                    cart.setUpdateTime(new Date());
                    //cookie.setValue(JSON.toJSONString(cart));
                    Cookie c = new Cookie(("addCart"+skuId), JSON.toJSONString(cart));
                    response.addCookie(c);
                    flag=1;
                    break;
                }
            }
        }
        if(flag==0){
            //3.如果没有，就插入
            Cart cart = new Cart();
            cart.setSkuId(skuId);
            Sku sku = skuService.getSkuById(skuId);
            cart.setId(skuId);
            cart.setTitle(sku.getTitle());
            cart.setPrice(sku.getPrice());
            cart.setImage(sku.getImage());
            cart.setPnum(pnum);
            cart.setCreateTime(new Date());
            Cookie cookie = new Cookie(("addCart"+skuId), JSON.toJSONString(cart));
            response.addCookie(cookie);
        }
        return "redirect:/cartList2";
    }


    /**
     *  购物车列表展示 (cookie方式)
     * @param request
     * @param model
     * @return
     */
    @RequestMapping("/cartList2")
    public String list(HttpServletRequest request, Model model) {
        Integer totalPrice = 0;
        Integer total = 0;
        Cookie[] cookies = request.getCookies();
        List<Cart> cartList=new ArrayList<>();
        String cartStr="";
        if(cookies!=null && cookies.length>0){
            for (Cookie cookie : cookies) {
                if (cookie.getName().contains("addCart")) {
                    cartStr = cookie.getValue();
                    Cart cart = JSON.parseObject(cartStr, Cart.class);
                    cartList.add(cart);
                    if(cart.getPrice()!=null && cart.getPnum()!=null){
                        cart.setSubPrice(cart.getPrice()*cart.getPnum());
                    }
                    if(cart.getSubPrice()!=null){
                        totalPrice += cart.getSubPrice();
                    }
                    if(cart.getPnum()!=null){
                        total += cart.getPnum();
                    }
                }
            }
        }
        List<Category> navCategories = categoryService.getAllCategories();
        model.addAttribute("total1", cartList.size());
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("total", total);
        model.addAttribute("cartList", cartList);
        request.setAttribute("navCategories", navCategories);
        return "cart2";
    }

    /**
     *  更新数量
     * @param id
     * @param pnum
     */
    @RequestMapping("/updateNum")
    @ResponseBody
    public void updateNum(Integer id, Integer pnum, HttpServletRequest request, HttpServletResponse response) {
        Cookie[] cookies = request.getCookies();
        String cartStr="";
        if(cookies!=null && cookies.length>0){
            for (Cookie cookie : cookies) {
                if (("addCart"+id).equalsIgnoreCase(cookie.getName())) {
                    cartStr = cookie.getValue();
                    Cart cart = JSON.parseObject(cartStr, Cart.class);
                    cart.setPnum(pnum);
                    cart.setUpdateTime(new Date());
                    Cookie c = new Cookie(("addCart"+id), JSON.toJSONString(cart));
                    response.addCookie(c);
                    break;
                }
            }
        }
    }

    /**
     *  删除购物项
     * @param ids
     * @return
     */
    @RequestMapping("/deleteCartItems")
    @ResponseBody
    public boolean deleteCartItems(Integer[] ids, HttpServletRequest request, HttpServletResponse response) {
        Cookie[] cookies = request.getCookies();
        for (Integer id : ids) {
            if(cookies!=null && cookies.length>0){
                for (Cookie cookie : cookies) {
                    if (("addCart"+id).equalsIgnoreCase(cookie.getName())) {
                        cookie.setMaxAge(0);
                        cookie.setPath("/");
                        response.addCookie(cookie);
                        break;
                    }
                }
            }
        }
        return true;
    }

}
