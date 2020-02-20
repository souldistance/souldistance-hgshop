package com.songyinglong.hgshop.vo;

import com.songyinglong.hgshop.entity.Spu;
import lombok.Data;

/**
 * @author SongYinglong
 * @date 2020/2/4- 2020/2/4
 */
@Data
public class SpuVO extends Spu{

    private String keyword;

    private Integer optionId;
}
