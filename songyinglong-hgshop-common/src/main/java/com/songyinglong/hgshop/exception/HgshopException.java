package com.songyinglong.hgshop.exception;

/** 
* @author 作者:SongYinglong
* @version 创建时间：2020年1月10日 下午2:07:42
* 类功能说明 
*/
public class HgshopException extends RuntimeException {

	/**
	 * @fieldName: serialVersionUID
	 * @fieldType: long
	 * @Description: TODO
	 */
	private static final long serialVersionUID = 1L;
	
	private String message;

	@Override
	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public HgshopException(String message) {
		super(message);
		this.message = message;
	}

	public HgshopException() {
		super();
	}
}
