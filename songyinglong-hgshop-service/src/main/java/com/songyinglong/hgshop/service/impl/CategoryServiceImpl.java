package com.songyinglong.hgshop.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.songyinglong.hgshop.entity.Category;
import com.songyinglong.hgshop.exception.HgshopAjaxException;
import com.songyinglong.hgshop.mapper.CategoryMapper;
import com.songyinglong.hgshop.service.CategoryService;
import org.apache.dubbo.config.annotation.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author SongYinglong
 * @date 2020/1/20- 2020/1/20
 */
@Service
public class CategoryServiceImpl implements CategoryService{

    @Resource
    private CategoryMapper categoryMapper;
    /**
     * 分类列表展示
     * @param category
     * @param pageNum
     * @param pageSize
     * @return
     */
    @Override
    public PageInfo<Category> categoryList(Category category, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Category> categories = categoryMapper.selectByExample(category);
        return  new PageInfo<Category>(categories);
    }

    /**
     * 分类添加或编辑页面显示tree
     * @return
     */
    @Override
    public List<Category> getAllCategories() {
        return categoryMapper.selectAllCategories();
    }

    /**
     * 添加或编辑分类
     * @param category
     * @return
     */
    @Override
    public void addOrUpdateCategory(Category category) {
        if(category.getId()==null){
            categoryMapper.insert(category);
        }else{
            categoryMapper.updateByPrimaryKey(category);
            categoryMapper.deleteBrandCategory(category.getId());
            categoryMapper.deleteCategorySpecByCategoryId(category.getId());
        }
        if(category.getLevel()!=null && category.getLevel()==3){
            //添加 分类品牌中间表数据
            if(category.getBrands()!=null && category.getBrands().size()>0){
                category.getBrands().forEach(brand -> {
                    if(brand.getId()!=null){
                        categoryMapper.insertBrandCategory(brand.getId(),category.getId());
                    }
                });
            }
            //添加 分类规格参数中间表数据
            if(category.getSpecs()!=null && category.getSpecs().size()>0){
                category.getSpecs().forEach(spec -> {
                    if(spec.getId()!=null){
                        categoryMapper.insertCategorySpec(category,spec);
                    }
                });
            }
        }
    }

    /**
     * 修改回显和详情
     * @param id
     * @return
     */
    @Override
    public Category getCategoryById(Integer id) {
        return categoryMapper.selectByPrimaryKey(id);
    }

    /**
     * 删除分类
     * @param id
     */
    @Override
    public void deleteCategory(Integer id) throws HgshopAjaxException{
        //1.判定当前分类节点是否有子分类。如果有，不能删除，提示有叶子节点
        Integer count = categoryMapper.getChildCategoryCount(id);
        if(count>0){
            throw new HgshopAjaxException(20011,"该分类下有子分类,不能删除!");
        }else{
            //2.如果当前分类下没有子分类，将该分类下所有商品信息中category_id设置为null
            //3.删除该分类
            count = categoryMapper.deleteByPrimaryKey(id);
            if (count == 0) {
                throw new HgshopAjaxException(20012,"删除分类失败!");
            }else {
                //删除成功后删除分类与品牌中间表和与规格参数中间表中的数据
                categoryMapper.deleteBrandCategory(id);
                categoryMapper.deleteCategorySpecByCategoryId(id);
            }
        }
    }

    /**
     * (sku添加或修改时 查询该分类下的规格参数 及 spu)
     * @param id
     * @return
     */
    @Override
    public Category getCategoryById2(Integer id) {
        return categoryMapper.selectSpecsAndSpusByCatrgory(id);
    }
}
