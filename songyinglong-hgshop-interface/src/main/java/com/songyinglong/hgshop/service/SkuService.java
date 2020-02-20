package com.songyinglong.hgshop.service;

import com.github.pagehelper.PageInfo;
import com.songyinglong.hgshop.entity.Sku;

import java.util.List;
import java.util.Map;

/**
 * @author SongYinglong
 * @date 2020/1/29- 2020/1/29
 */
public interface SkuService {

    /**
     *  sku 列表展示  标题卖点模糊查询
     * @param sku
     * @param pageNum
     * @param pageSize
     * @return
     */
    PageInfo<Sku> skuList(Sku sku, Integer pageNum, Integer pageSize);

    /**
     *  删除sku功能
     * @param ids
     */
    void deleteSkuByIds(Integer[] ids);

    /**
     *  根据skuId查询sku数据 (修改前回显,查看详情)
     * @param id
     * @return
     */
    Sku getSkuById(Integer id);

    /**
     *  sku添加或修改
     * @param sku
     */
    void saveOrUpdateSku(Sku sku);

    /**
     * 查询最新商品数据
     * @param pageSize
     * @return
     */
    List<Sku> selectNews(int pageSize);

    /**
     *  通过skuId查询sku有关信息 （关联hg_sku_spec中间表 获得specId optionId 便于数据回显 规格参数选中 ）
     * @param id
     * @return
     */
    Map<String,Object> getSkuById1(Integer id);

    /**
     *  通过规格参数选项ids查询
     * @param optionIds
     * @return
     */
    Map<String,Object> getSkuBySpecOptionIds(Integer[] optionIds, Integer spuId);

    Sku getSkuById2(Integer skuId);
}
