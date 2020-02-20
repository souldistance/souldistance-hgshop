package com.songyinglong.hgshop.listener;

import com.alibaba.fastjson.JSON;
import com.songyinglong.hgshop.entity.Spec;
import com.songyinglong.hgshop.entity.SpecOption;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.data.redis.core.ListOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.kafka.listener.MessageListener;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

/**
 * @author SongYinglong
 * @date 2020/1/25- 2020/1/25
 */
//@Component
public class KafkaConsumerListener implements MessageListener<String,String>{

    @Resource
    private RedisTemplate<String,Spec> specOptionRedisTemplate;

    @Override
    public void onMessage(ConsumerRecord<String, String> data) {
        if(data!=null){
            String key = data.key();
            if(key==null){
                return;
            }
            ListOperations listOperations = specOptionRedisTemplate.opsForList();
            if("saveOrUpdateSpec".equals(key)){
                Spec spec = JSON.parseObject(data.value(), Spec.class);
                List<SpecOption> specOptions=new ArrayList<>();
                spec.getSpecOptions().forEach(specOption -> {
                    if(specOption!=null && specOption.getOptionName()!=null && !"".equals(specOption)){
                        specOptions.add(specOption);
                    }
                });
                spec.setSpecOptions(specOptions);
                if (spec.getId() == null) {
                    //1.新增
                    //(2)	使用Kafka消费者接收数据，并将数据存储到Redis中。
                    spec.setId(listOperations.size("specOptions").intValue());
                    listOperations.rightPush("specOptions",spec);
                } else{
                    //2.修改
                    //使用Kafka消费者接收数据，并将数据存储到Redis中
                    listOperations.set("specOptions",spec.getId(),spec);
                }
            }else if("deleteSpec".equals(key)){
                List<Integer> ids = JSON.parseArray(data.value(), Integer.class);
                ListOperations<String, Spec> opsForList = specOptionRedisTemplate.opsForList();
                for (Integer id : ids) {
                    opsForList.remove("specOptions",0,opsForList.index("specOptions",id));
                }
                for (int i = 0; i < opsForList.size("specOptions"); i++) {
                    Spec spec = opsForList.index("specOptions", i);
                    spec.setId(i);
                    opsForList.set("specOptions",i,spec);
                }
            }
        }
    }
}
