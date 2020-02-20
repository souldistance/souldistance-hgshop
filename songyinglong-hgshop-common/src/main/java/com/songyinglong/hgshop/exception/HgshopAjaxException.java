package com.songyinglong.hgshop.exception;
/** 
* @author 作者:SongYinglong
* @version 创建时间：2020年1月10日 下午2:07:42
* 类功能说明  该类用于处理Ajax请求时所产生的异常
*/
public class HgshopAjaxException extends RuntimeException {

	/**
	 * @fieldName: serialVersionUID
	 * @fieldType: long
	 * @Description: 
	 */
	private static final long serialVersionUID = 1L;
	
	private String message;
	
	private Integer code;


	@Override
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

	public HgshopAjaxException() {
	}

	public HgshopAjaxException(Integer code, String message ) {
		super(message);
		this.message = message;
		this.code = code;
	}
}
