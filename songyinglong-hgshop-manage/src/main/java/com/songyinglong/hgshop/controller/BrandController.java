package com.songyinglong.hgshop.controller;

import com.github.pagehelper.PageInfo;
import com.songyinglong.hgshop.entity.Brand;
import com.songyinglong.hgshop.service.BrandService;
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
 * @date 2020/1/16- 2020/1/16
 */
@Controller
@RequestMapping("admin")
public class BrandController {

    @Reference
    private BrandService brandService;

    /**
     * 列表显示 分页功能 条件查询
     * @param brand
     * @param pageNum
     * @param pageSize
     * @param model
     * @return
     */
    @RequestMapping("/brands")
    public String queryBrands(Brand brand, @RequestParam(defaultValue = "1") Integer pageNum, @RequestParam(defaultValue = "3") Integer pageSize, Model model){
        PageInfo<Brand> pageInfo = brandService.queryBrands(brand, pageNum, pageSize);
        model.addAttribute("pg",pageInfo);
        model.addAttribute("brand",brand);
        return "brand/brands";
    }

    /**
     * 查询全部品牌
     * @return
     */
    @RequestMapping("/selectBrands")
    @ResponseBody
    public Result selectBrands(){
       List<Brand> brands = brandService.selectBrands();
       return ResultUtil.success(brands);
    }
    /**
     * 批量删除/单删 功能
     * @param ids
     * @return
     */
    @RequestMapping("deleteBrands")
    @ResponseBody
    public Result deleteBrands(Integer []ids){
       brandService.deleteBrands(ids);
        return ResultUtil.success();
    }

    /**
     * 添加品牌功能
     * @param brand
     * @return
     */
    @RequestMapping("brandAdd")
    @ResponseBody
    public Result brandAdd(Brand brand){
        brandService.brandAdd(brand);
        return ResultUtil.success();
    }

    /**
     * 根据ID查看品牌
     * @param id
     * @return
     */
    @RequestMapping("getBrandById")
    @ResponseBody
    public Result getBrandById(Integer id){
        Brand brand=brandService.getBrandById(id);
        return ResultUtil.success(brand);
    }


    /**
     * 根据ID修改品牌
     * @param brand
     * @return
     */
    @RequestMapping("editBrand")
    @ResponseBody
    public Result editBrand(Brand brand){
        brandService.editBrand(brand);
        return ResultUtil.success();
    }


}
