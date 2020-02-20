package com.songyinglong.hgshop.service;

import com.github.pagehelper.PageInfo;
import com.songyinglong.hgshop.entity.Category;
import com.songyinglong.hgshop.exception.HgshopAjaxException;

import java.util.List;

/**
 * @author SongYinglong
 * @date 2020/1/20- 2020/1/20
 */
public interface CategoryService {

    /**
     * 分类列表
     * @param category
     * @param pageNum
     * @param pageSize
     * @return
     */
    PageInfo<Category> categoryList(Category category, Integer pageNum, Integer pageSize);

    /**
     * 分类添加或编辑页面显示tree
     * @return
     */
    List<Category> getAllCategories();

    /**
     * 添加或编辑分类
     * @param category
     * @return
     */
    void addOrUpdateCategory(Category category);

    /**
     * 修改回显和详情
     * @param id
     * @return
     */
    Category getCategoryById(Integer id);

    /**
     *  删除分类
     * @param id
     */
    void deleteCategory(Integer id) throws HgshopAjaxException;

    /**
     *  (sku添加或修改时 查询该分类下的规格参数 及 spu)
     * @param id
     * @return
     */
    Category getCategoryById2(Integer id);
}
