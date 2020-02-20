package com.songyinglong.hgshop.controller;

import com.songyinglong.hgshop.entity.Cart;
import com.songyinglong.hgshop.entity.Category;
import com.songyinglong.hgshop.entity.User;
import com.songyinglong.hgshop.service.CartService;
import com.songyinglong.hgshop.service.CategoryService;
import org.apache.dubbo.config.annotation.Reference;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@RequestMapping("/cartdb")
@Controller
public class CartDBController {

	@Reference
	private CartService cartService;

	@Reference
	private CategoryService categoryService;


	/**
	 *  加入购物车
	 * @param request
	 * @param skuId
	 * @param pnum
	 * @return
	 */
	@RequestMapping("/addCart")
	public String addCart(HttpServletRequest request, Integer skuId, Integer pnum) {
		//1.查询数据库中有没有该skuId对应的购物项
		User user = (User) request.getAttribute("user");
		Integer userId = user.getUid();
		Cart cart = cartService.getCartByKey(userId, skuId);
		//2.如果有，就修改数量
		if (cart != null) {
			cartService.updateNum(cart.getId(), cart.getPnum() + pnum);
		} else {
			//3.如果没有，就插入
			cart = new Cart();
			cart.setSkuId(skuId);
			cart.setPnum(pnum);
			cart.setUid(userId);
			cartService.addCart(cart);
		}
		return "redirect:/cartdb/cartList";
	}

	/**
	 *  购物车列表展示
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping("/cartList")
	public String list(HttpServletRequest request, Model model) {
		Integer totalPrice = 0;
		Integer total = 0;

		List<Category> navCategories = categoryService.getAllCategories();
		User user = (User) request.getAttribute("user");
		Integer userId = user.getUid();
		List<Cart> list = cartService.list(userId);
		for (Cart cart : list) {
			cart.setSubPrice(cart.getPrice()*cart.getPnum());
			totalPrice += cart.getSubPrice();
			total += cart.getPnum();
		}
		model.addAttribute("total1", list.size());
		model.addAttribute("totalPrice", totalPrice);
		model.addAttribute("total", total);
		model.addAttribute("cartList", list);
		request.setAttribute("navCategories", navCategories);
		return "cart";
	}

	/**
	 *  更新数量
	 * @param id
	 * @param pnum
	 */
	@RequestMapping("/updateNum")
	@ResponseBody
	public void updateNum(Integer id, Integer pnum) {
		cartService.updateNum(id, pnum);
	}

	/**
	 *  删除购物项
	 * @param ids
	 * @return
	 */
	@RequestMapping("/deleteCartItems")
	@ResponseBody
	public boolean deleteCartItems(Integer[] ids) {
		cartService.deleteCartItems(ids);
		return true;
	}


	/**
	 *  清空购物项
	 * @param request
	 * @return
	 */
	@RequestMapping("/clearCart")
	public String clearCart(HttpServletRequest request) {
		User user = (User) request.getAttribute("user");
		Integer userId = user.getUid();
		cartService.clearCart(userId);
		return "redirect:/cartdb/cartList";
	}
	
	
	
	
	
}
