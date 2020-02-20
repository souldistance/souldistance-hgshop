package com.songyinglong.hgshop.util;

/**
 * @author 作者:SongYinglong
 * @version 创建时间：2020年1月10日 下午2:07:42
 */
public class ResultUtil {

	/**
	 * 
	 * @Title: success
	 * @Description: 当ajax请求成功时 返回json格式对象
	 * @param data
	 * @return
	 * @return: Result
	 */
	public static Result success(Object data) {
		Result result = new Result();
		result.setData(data);
		result.setCode(0);
		result.setMessage("成功");
		return result;
	}

	/**
	 * 
	 * @Title: success
	 * @Description: 当ajax请求成功时 不用返回对象
	 * @return
	 * @return: Result
	 */
	public static Result success() {
		return success(null);
	}

	/**
	 * 
	 * @Title: error
	 * @Description: 当ajax 请求失败时返回 状态码和消息
	 * @param code
	 * @param message
	 * @return
	 * @return: Result
	 */
	public static Result error(Integer code, String message) {
		Result result = new Result();
		result.setCode(code);
		result.setMessage(message);
		return result;
	}

}

