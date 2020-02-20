package com.songyinglong.hgshop.controller;

import com.github.pagehelper.PageInfo;
import com.songyinglong.hgshop.entity.Sku;
import com.songyinglong.hgshop.entity.Spu;
import com.songyinglong.hgshop.service.SkuService;
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
import java.util.UUID;

/**
 * @author SongYinglong
 * @date 2020/1/29- 2020/1/29
 */
@RequestMapping("admin")
@Controller
public class SkuController {

    @Reference
    private SkuService skuService;

    @Reference
    private SpuService spuService;


    /**
     *  sku 列表展示  标题卖点模糊查询
     * @param model
     * @param sku
     * @param pageNum
     * @param pageSize
     * @return
     */
    @RequestMapping("skuList")
    public String skuList(Model model,   Sku sku, @RequestParam(defaultValue="1")Integer pageNum, @RequestParam(defaultValue="2")Integer pageSize) {
        PageInfo<Sku> pageInfo = skuService.skuList(sku, pageNum, pageSize);
        model.addAttribute("pg", pageInfo);
        model.addAttribute("sku", sku);
        return "sku/sku_list";
    }

    /**
     *  删除sku功能
     * @param ids
     * @return
     */
    @RequestMapping("/skuDelete")
    @ResponseBody
    public Result skuDelete(Integer[] ids) {
        skuService.deleteSkuByIds(ids) ;
        return ResultUtil.success();
    }

    /**
     *  根据skuId查询sku数据 (修改前回显,查看详情)
     * @param id
     * @return
     */
    @RequestMapping("/getSkuById")
    @ResponseBody
    public Result getSkuById(Integer id) {
        return ResultUtil.success(skuService.getSkuById(id));
    }

    /**
     *  sku添加或修改
     * @param sku
     * @param file
     * @return
     * @throws IllegalStateException
     * @throws IOException
     */
    @RequestMapping("/skuAdd")
    @ResponseBody
    public Result skuAdd(Sku sku, MultipartFile file) throws IllegalStateException, IOException, Exception {
        if(file!=null){
            String originalFilename = file.getOriginalFilename();
            if (StringUtils.isNotBlank(originalFilename)) {
                String fileName = UUID.randomUUID() + "_" + originalFilename;
                File destFile = new File("D://pic/", fileName);
                if (!destFile.getParentFile().exists()) {
                    destFile.getParentFile().mkdirs();
                }
                file.transferTo(destFile);

                String oldPath = sku.getImage();
                if (StringUtils.isNotBlank(oldPath)) {
                    FileUtils.forceDelete(new File("D://pic/" + oldPath));
                }
                sku.setImage(fileName);
            }
        }
        skuService.saveOrUpdateSku(sku);
        Spu spu = spuService.getSpuById(sku.getSpuId());
        if(("0").equals(spu.getIsMarketable())){
            spuService.saveOrUpdateESSpu(spu.getId());
        }
        return ResultUtil.success();
    }
}
