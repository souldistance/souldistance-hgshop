package com.songyinglong.hgshop.controller;

import com.github.pagehelper.PageInfo;
import com.songyinglong.hgshop.entity.Category;
import com.songyinglong.hgshop.service.CategoryService;
import com.songyinglong.hgshop.util.Result;
import com.songyinglong.hgshop.util.ResultUtil;
import org.apache.dubbo.config.annotation.Reference;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * @author SongYinglong
 * @date 2020/1/20- 2020/1/20
 */
@RequestMapping("admin")
@Controller
public class CategoryController {

    @Reference
    private CategoryService categoryService;

    /**
     * 分类分页列表
     * @param model
     * @param category
     * @param pageNum
     * @param pageSize
     * @return
     */
    @RequestMapping("/categories")
    public String categoryList(Model model, Category category, @RequestParam(defaultValue="1")Integer pageNum, @RequestParam(defaultValue="3")Integer pageSize) {
        //1.获取数据
        PageInfo<Category> pageInfo = categoryService.categoryList(category, pageNum, pageSize);
        //2.填充数据
        model.addAttribute("pg", pageInfo);
        model.addAttribute("category", category);
        return "category/category_list";
    }

    /**
     *分类添加或编辑页面显示tree
     * @return
     */
    @RequestMapping("/getAllCategories")
    @ResponseBody
    public Result getAllCategories(){
        List<Category> categories=categoryService.getAllCategories();
        return ResultUtil.success(categories);
    }

    /**
     * 查询分类tree，控制一级二级分类不能选中
     * @return
     */
    @RequestMapping("/getAllCategories1")
    @ResponseBody
    public Result getAllCategories1(){
        List<Category> categories=categoryService.getAllCategories();
        categories.forEach(c1 -> {
            c1.setSelectable(false);
            if(c1.getChilds()!=null && c1.getChilds().size()>0){
                c1.getChilds().forEach(c2 -> c2.setSelectable(false));
            }
        });
        return ResultUtil.success(categories);
    }

    /**
     * 添加或编辑分类
     * @param category
     * @return
     */
    @RequestMapping("/categoryAddOrUpdate")
    @ResponseBody
    public Result categoryAdd(Category category){
        categoryService.addOrUpdateCategory(category);
        return ResultUtil.success() ;
    }

    /**
     * 修改回显和详情 (spu添加或修改时 查询该分类下的品牌)
     * @param id
     * @return
     */
    @RequestMapping("/getCategoryById")
    @ResponseBody
    public Result getCategoryById(Integer id) {

        return ResultUtil.success(categoryService.getCategoryById(id));
    }

    /**
     *  (sku添加或修改时 查询该分类下的规格参数 及 spu)
     * @param id
     * @return
     */
    @RequestMapping("/getCategoryById2")
    @ResponseBody
    public Result getCategoryById2(Integer id) {

        return ResultUtil.success(categoryService.getCategoryById2(id));
    }
    /**
     * 删除分类
     * @param id
     * @return
     */
    @RequestMapping("/categoryDelete")
    @ResponseBody
    public Result categoryDelete(Integer id){
        categoryService.deleteCategory(id);
        return ResultUtil.success();
    }
}
