package com.songyinglong.hgshop;


import com.songyinglong.hgshop.entity.Spu;
import com.songyinglong.hgshop.mapper.SpuMapper;
import com.songyinglong.hgshop.service.SearchSpuService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;
import java.util.List;


@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"classpath:spring.xml"})
public class ESTest {

//	@Reference(url="dubbo://localhost:20890",timeout=5000)
	@Resource
	private SearchSpuService spuService;
	
	@Resource
    private SpuMapper spuMapper;
	
	@Test
	public void testSave() {
		try {
			spuService.saveOrUpdateESSpu(7);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

    /**
     * 商品导入程序
     */
    @Test
    public void testBatchSave() {
        List<Spu> spus = spuMapper.selectSpuAll();
        spus.forEach(spu -> {
            try {
                spuService.saveOrUpdateESSpu(spu.getId());
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
    }
}
