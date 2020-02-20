package com.songyinglong.hgshop.controller;

import com.songyinglong.hgshop.entity.Category;
import com.songyinglong.hgshop.entity.Sku;
import com.songyinglong.hgshop.service.CategoryService;
import com.songyinglong.hgshop.service.SearchSpuService;
import com.songyinglong.hgshop.service.SkuService;
import com.songyinglong.hgshop.service.SpuService;
import com.songyinglong.hgshop.vo.SpuVO;
import org.apache.commons.lang3.StringUtils;
import org.apache.dubbo.config.annotation.Reference;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * @author Souldistance
 */
@Controller
public class IndexController {

	@Reference
	private CategoryService categoryService;
	
	@Reference
	private SkuService skuService;
	
	@Reference
	private SpuService spuService;

	@Reference
	private SearchSpuService searchSpuService;
	/**
	 * 前台首页
	 * @param request
	 * @return
	 */
	@RequestMapping("/")
	public String index(HttpServletRequest request) {
		//1.查询导航中的数据
		List<Category> navCategories = categoryService.getAllCategories();
		
		//2.查询最新商品数据
		List<Sku> newSkus = skuService.selectNews(4);
		
//		List<Sku> hotSkus = spuSkuService.selectHots(4);
		
		//存储数据
		request.setAttribute("navCategories", navCategories);
		request.setAttribute("newSkus", newSkus);
//		request.setAttribute("hotSkus", hotSkus);

		return "index";
	}


	/**
	 * 搜索页
	 * @param spuVO
	 * @param pageNum
	 * @param pageSize
	 * @param model
	 * @return
	 */
	@RequestMapping("/list")
	public String list(SpuVO spuVO, @RequestParam(defaultValue="1")Integer pageNum, @RequestParam(defaultValue="20")Integer pageSize, Model model) {
		Map<String, Object> map = spuService.getSpuList(spuVO, pageNum, pageSize);
		model.addAttribute("spuVO",spuVO);
		model.addAttribute("keyword", spuVO.getKeyword());
		model.addAttribute("map", map);
		//1.查询导航中的数据
		List<Category> navCategories = categoryService.getAllCategories();
		model.addAttribute("navCategories", navCategories);
		return "list";
	}

	/**
	 *  搜索页 elasticsearch查询 高亮显示
	 * @param keyword
	 * @param brandId
	 * @param categoryId
	 * @param k
	 * @param v
	 * @param pageNum
	 * @param pageSize
	 * @param request
	 * @return
	 */
	@RequestMapping("/list2")
	public String list2(String keyword, Integer brandId, Integer categoryId, String k, String v, @RequestParam(defaultValue="1")Integer pageNum, @RequestParam(defaultValue="20")Integer pageSize, HttpServletRequest request) {
		Map<String, String> filter = new HashMap<>();
		if (brandId != null){
			filter.put("brandId", brandId+"");
		}
		if (categoryId != null) {
			filter.put("categoryId", categoryId+"");
		}
		if (StringUtils.isNotEmpty(k) && StringUtils.isNotEmpty(v)){
			filter.put(k, v);
		}
		Map<String, Object> map = searchSpuService.search(keyword, pageNum, pageSize, filter);
		request.setAttribute("map", map);
		request.setAttribute("keyword", keyword);
		//1.查询导航中的数据
		List<Category> navCategories = categoryService.getAllCategories();
		request.setAttribute("navCategories", navCategories);
		return "list2";
	}

	/**
	 * 详情页
	 * @param request
	 * @param id
	 * @param optionIds
	 * @return
	 */
	@RequestMapping("/page")
	public String page(HttpServletRequest request, Integer id, Integer[] optionIds, Integer spuId) {
		Map<String, Object> map = new HashMap<>();
		if (id != null) {
			//通过skuId查询
			map = skuService.getSkuById1(id);
		} else {
			//通过规格参数选项ids查询
			map = skuService.getSkuBySpecOptionIds(optionIds,spuId);
		}
		List<Category> navCategories = categoryService.getAllCategories();
		request.setAttribute("navCategories", navCategories);
		request.setAttribute("map", map);
		return "page";
	}
}
