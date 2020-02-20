package com.songyinglong.hgshop.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.songyinglong.hgshop.entity.Brand;
import com.songyinglong.hgshop.entity.BrandExample;
import com.songyinglong.hgshop.mapper.BrandMapper;
import com.songyinglong.hgshop.service.BrandService;
import org.apache.dubbo.config.annotation.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author SongYinglong
 * @date 2020/1/16- 2020/1/16
 */
@Service
public class BrandsServiceImpl implements BrandService{

    @Resource
    private BrandMapper brandMapper;

    @Override
    public PageInfo<Brand> queryBrands(Brand brand, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum,pageSize);
        BrandExample brandExample = new BrandExample();
        BrandExample.Criteria criteria = brandExample.createCriteria();
        if(brand.getName()!=null && !brand.getName().equals("")){
            criteria.andNameLike("%"+brand.getName()+"%");
        }
        if(brand.getFirstChar()!=null && !brand.getFirstChar().equals("")){
            criteria.andFirstCharEqualTo(brand.getFirstChar());
        }
        List<Brand> brands = brandMapper.selectByExample(brandExample);
        return new PageInfo<>(brands,5);
    }

    /**
     *  删除品牌功能
     * @param ids
     * @return
     */
    @Override
    public void deleteBrands(Integer[] ids) {
        Brand brand = new Brand();
        brand.setDeletedFlag(true);
        for (Integer id : ids) {
            brand.setId(id);
            brandMapper.updateByPrimaryKeySelective(brand);
            //brandMapper.deleteByPrimaryKey(id);
        }
    }

    /**
     * 添加品牌功能
     * @param brand
     */
    @Override
    public void brandAdd(Brand brand) {
        //添加时 设置默认状态是未删除  true表示未删除
        brand.setDeletedFlag(true);
        brandMapper.insert(brand);
    }

    /**
     * 根据ID查看品牌
     * @param id
     * @return Brand
     */
    @Override
    public Brand getBrandById(Integer id) {
        return brandMapper.selectByPrimaryKey(id);
    }

    /**
     * 根据品牌ID修改品牌信息
     * @param brand
     */
    @Override
    public void editBrand(Brand brand) {
        brandMapper.updateByPrimaryKeySelective(brand);
    }

    /**
     * 查询全部品牌
     * @return
     */
    @Override
    public List<Brand> selectBrands() {
        return brandMapper.selectBrands();
    }
}
