package com.songyinglong.hgshop.util;
/** 
* @author 作者:SongYinglong
* @version 创建时间：2020年1月10日 下午2:07:42
* 类功能说明 
*/
public class Result {
	/**
	 * 消息
	 */
	private String message;

	/**
	 * 状态码
	 */
	private Integer code;

	/**
	 * 返回前台的数据
	 */
	private Object data;

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public Integer getCode() {
		return code;
	}

	public void setCode(Integer code) {
		this.code = code;
	}

	public Object getData() {
		return data;
	}

	public void setData(Object data) {
		this.data = data;
	}

}
