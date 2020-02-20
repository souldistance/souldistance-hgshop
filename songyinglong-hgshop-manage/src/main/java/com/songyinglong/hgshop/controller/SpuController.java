package com.songyinglong.hgshop.controller;

import com.github.pagehelper.PageInfo;
import com.songyinglong.hgshop.entity.Spu;
import com.songyinglong.hgshop.service.SpuService;
import com.songyinglong.hgshop.util.Result;
import com.songyinglong.hgshop.util.ResultUtil;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.dubbo.config.annotation.Reference;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @author SongYinglong
 * @date 2020/1/28- 2020/1/28
 */
@RequestMapping("admin")
@Controller
public class SpuController {

    @Reference
    private SpuService spuService;

    /**
     * 分类树结构页面
     * @return
     */
    @RequestMapping("/spuShowCategoryTree")
    public String showCategoryTree() {
        return "spu/spu_CategoryTree";
    }


    /**
     * spu列表查询
     * @param model
     * @param spu
     * @param pageNum
     * @param pageSize
     * @return
     */
    @RequestMapping("/spuList")
    public String specList(Model model, Spu spu, @RequestParam(defaultValue="1")Integer pageNum, @RequestParam(defaultValue="3")Integer pageSize) {
        PageInfo<Spu> pageInfo = spuService.spuList(spu, pageNum, pageSize);
        model.addAttribute("spu", spu);
        model.addAttribute("pg", pageInfo);
        return "spu/spu_list";
    }

    /**
     * spu删除功能
     * @param ids
     * @return
     */
    @RequestMapping("/spuDelete")
    @ResponseBody
    public Result spuDelete(Integer[] ids) {
        spuService.deleteSpuByIds(ids);
        return ResultUtil.success();
    }

    /**
     *  根据id获取spu数据
     * @param id
     * @return
     */
    @RequestMapping("/getSpuById")
    @ResponseBody
    public Result getSpuById(Integer id) {
        return ResultUtil.success(spuService.getSpuById(id));
    }

    /**
     *  spu添加或者修改
     * @param spu
     * @param file
     * @return
     * @throws IllegalStateException
     * @throws IOException
     */
    @RequestMapping("/spuAdd")
    @ResponseBody
    public Result spuAdd(Spu spu, MultipartFile file) throws IllegalStateException, IOException, Exception {
        if(file!=null){
            //1.如果有图片，就上传图片；如果没有，就跳过
            String fileName = file.getOriginalFilename();
            if (StringUtils.isNotBlank(fileName)) {
                //1.1.生成存放图片的路径
                //G://pic
                //G://pic/20200111
                //G://pic/20200112
                String date = new SimpleDateFormat("yyyyMMdd").format(new Date());
                fileName = date + "/" + fileName;
                //File destFile = new File("G://pic"+File.separator+date, fileName);
                File destFile = new File("D://pic", fileName);

                if (!destFile.getParentFile().exists()) {
                    destFile.getParentFile().mkdirs();
                }
                //1.2.上传图片
                file.transferTo(destFile);
                //1.3.如果是修改操作，并且替换成了新图片，需要删除之前的旧图片
                if (StringUtils.isNotBlank(spu.getSmallPic())) {
                    //不好使,试试
//				new File("G://pic/" + spu.getSmallPic()).delete();
                    //jetty:run 报错!
                    //tomcat7:run 报错! 本地仓库的jar包替换一下
                    FileUtils.forceDelete(new File("D://pic/" + spu.getSmallPic()));
                }
                //1.4.给spu的smallPic属性赋值
                spu.setSmallPic(fileName);
            }
        }
        //2.保持spu信息
        spuService.saveOrUpdateSpu(spu);
        return  ResultUtil.success();
    }


    /**
     *  查询全部spu信息 (sku添加或修改时 spu集合下拉框选择)
     * @return
     */
    @RequestMapping("/selectSpuAll")
    @ResponseBody
    public Result selectSpuAll() {
        return ResultUtil.success(spuService.selectSpuAll());
    }


    /**
     * spu商品审核功能
     * @param ids
     * @return
     */
    @RequestMapping("/spuMarketable")
    @ResponseBody
    public Result spuMarketable(Spu spu) throws Exception  {
        spuService.spuMarketable(spu);
        return ResultUtil.success();
    }
}
