package com.songyinglong.hgshop.service;

import java.util.Map;

/**
 * @author SongYinglong
 * @date 2020/2/18- 2020/2/18
 */
public interface SearchSpuService {

    /**
     *  根据spuId把spu有关数据存储到es中
     * @param spuId
     * @throws Exception
     */
    void saveOrUpdateESSpu(Integer spuId)  throws Exception ;

    /**
     * elasticsearch搜索
     * @param keyword
     * @param pageNum
     * @param pageSize
     * @param filter
     * @return
     */
    Map<String,Object> search(String keyword, Integer pageNum, Integer pageSize, Map<String, String> filter);

}
