package com.songyinglong.hgshop.controller;

import com.github.pagehelper.PageInfo;
import com.songyinglong.hgshop.entity.Spec;
import com.songyinglong.hgshop.entity.SpecOption;
import com.songyinglong.hgshop.service.SpecService;
import com.songyinglong.hgshop.util.Result;
import com.songyinglong.hgshop.util.ResultUtil;
import org.apache.dubbo.config.annotation.Reference;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;

/**
 * @author SongYinglong
 * @date 2020/1/21- 2020/1/21
 */
@Controller
@RequestMapping("admin")
public class SpecController {

    @Reference
    private SpecService specService;


    /**
     * 分类树结构页面
     * @return
     */
    @RequestMapping("/specShowCategoryTree")
    public String showCategoryTree() {
        return "specOption/spec_CategoryTree";
    }

    /**
     * 规格参数列表查询
     * @param model
     * @param spec
     * @param pageNum
     * @param pageSize
     * @return
     */
    @RequestMapping("/specList")
    public String specList(Model model, Spec spec, @RequestParam(defaultValue="1")Integer pageNum, @RequestParam(defaultValue="3")Integer pageSize) {
        PageInfo<Spec> pageInfo = specService.specList(spec, pageNum, pageSize);
        model.addAttribute("spec", spec);
        model.addAttribute("pg", pageInfo);
        return "specOption/spec_list";
    }

    /**
     * 规格参数列表查询（在redis中查询）
     * @param model
     * @param pageNum
     * @param pageSize
     * @return
     */
    @RequestMapping("/specList1")
    public String specList1(Model model, @RequestParam(defaultValue="1")Integer pageNum, @RequestParam(defaultValue="3")Integer pageSize) {
        PageInfo<Spec> pageInfo = specService.specList( pageNum, pageSize);
        model.addAttribute("pg", pageInfo);
        return "specOption/spec_list";
    }

    /**
     * 删除规格参数功能
     * @param ids
     * @return
     */
    @RequestMapping("/specDelete")
    @ResponseBody
    public Result specDelete(Integer[] ids){
        specService.deleteSpecByIds(ids);
        return ResultUtil.success();
    }

    /**
     * 删除规格参数功能
     * @param ids
     * @return
     */
    @RequestMapping("/specDelete1")
    @ResponseBody
    public Result specDelete1(Integer[] ids){
        specService.deleteSpecByIds1(ids);
        return ResultUtil.success();
    }

    /**
     *  点击修改或查看按钮时
     * @param id
     * @return
     */
    @RequestMapping("/getSpecById")
    @ResponseBody
    public Result getSpecById(Integer id) {
        return ResultUtil.success(specService.getSpecById(id));
    }

    /**
     *  点击修改或查看按钮时(在redis中查询)
     * @param id
     * @return
     */
    @RequestMapping("/getSpecById1")
    @ResponseBody
    public Result getSpecById1(Integer id) {
        return ResultUtil.success(specService.getSpecById1(id));
    }

    /**
     *添加规格参数
     * @param spec
     * @return
     */
    @RequestMapping("/addSpec")
    @ResponseBody
    public Result specAdd(Spec spec){
        specService.saveOrUpdateSpec(spec);
        return ResultUtil.success();
    }

    /**
     *修改规格参数
     * @param spec
     * @return
     */
    @RequestMapping("/editSpec")
    @ResponseBody
    public Result editSpec(Spec spec){
        specService.saveOrUpdateSpec(spec);
        return ResultUtil.success();
    }

    /**
     *添加或修改规格参数 (在redis中操作)
     * @param spec
     * @return
     */
    @RequestMapping("/saveOrUpdateSpec")
    @ResponseBody
    public Result saveOrUpdateSpec(Spec spec){
        specService.saveOrUpdateSpec1(spec);
        return ResultUtil.success();
    }

    /**
     *查询全部规格参数
     * @return
     */
    @RequestMapping("/selectSpecs")
    @ResponseBody
    public Result selectSpecs(){
        List<Spec> specs  =specService.selectSpecs();
        return ResultUtil.success(specs);
    }


    /**
     *  根据规格参数Id查询参数选项
     * @param specId
     * @return
     */
    @RequestMapping("/selectSpecOptionBySpecId")
    @ResponseBody
    public Result selectSpecOptionBySpecId(Integer specId,Integer i){
        List<SpecOption> specOptions = specService.selectSpecOptionBySpecId(specId);
        HashMap<String, Object> map = new HashMap<>();
        map.put("specOptions",specOptions);
        map.put("i",i);
        return ResultUtil.success(map);
    }
}
