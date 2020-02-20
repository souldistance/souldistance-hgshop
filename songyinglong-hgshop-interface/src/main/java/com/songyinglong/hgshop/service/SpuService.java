package com.songyinglong.hgshop.service;

import com.github.pagehelper.PageInfo;
import com.songyinglong.hgshop.entity.Spu;
import com.songyinglong.hgshop.vo.SpuVO;

import java.util.List;
import java.util.Map;

/**
 * @author SongYinglong
 * @date 2020/1/28- 2020/1/28
 */
public interface SpuService {

    /**
     *  spu列表查询
     * @param spu
     * @param pageNum
     * @param pageSize
     * @return
     */
    PageInfo<Spu> spuList(Spu spu, Integer pageNum, Integer pageSize);

    /**
     * spu删除功能
     * @param ids
     */
    void deleteSpuByIds(Integer[] ids);

    /**
     *  根据id获取spu数据
     * @param id
     * @return
     */
    Spu getSpuById(Integer id);

    /**
     *  spu添加或者修改
     * @param spu
     */
    void saveOrUpdateSpu(Spu spu) throws Exception;

    /**
     *  查询全部spu信息 (sku添加或修改时 spu集合下拉框选择)
     * @return
     */
    List<Spu> selectSpuAll();

    /**
     *  搜索页spu列表展示
     * @param spuVO
     * @param pageNum
     * @param pageSize
     * @return
     */
    Map<String,Object> getSpuList(SpuVO spuVO, Integer pageNum, Integer pageSize);

    void saveOrUpdateESSpu(Integer spuId)  throws Exception ;

    Map<String,Object> search(String keyword, Integer pageNum, Integer pageSize, Map<String, String> filter);

    /**
     *  商品审核 （上架下架）
     * @param spu
     */
    void spuMarketable(Spu spu) throws Exception ;
}
