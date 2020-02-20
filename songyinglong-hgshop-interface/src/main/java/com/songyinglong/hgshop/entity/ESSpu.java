package com.songyinglong.hgshop.entity;

import lombok.Data;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

/**
 * spu实体类
 * @author coolface
 *
 */
@Data
@Document(indexName="hgshop",type="spu",shards=1,replicas=1)
public class ESSpu implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Integer id;
	/**
	 * 品牌Id
	 */
	private Integer brandId;
	/**
	 * 分类Id
	 */
	private Integer categoryId;
	@Field(type=FieldType.Text,analyzer="ik_max_word")
	/**
	 * 关键字
	 */
	private String keyword;
	@Field(type=FieldType.Text,analyzer="ik_max_word")
	/**
	 * 标题
	 */
	private String title;
	private List<Sku> skus;
	private Map<String, Object> specs;
		
	
	public ESSpu() {
		super();
		// TODO Auto-generated constructor stub
	}




}

