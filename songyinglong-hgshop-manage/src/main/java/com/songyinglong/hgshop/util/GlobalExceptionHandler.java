package com.songyinglong.hgshop.util;


import com.songyinglong.hgshop.exception.HgshopAjaxException;
import com.songyinglong.hgshop.exception.HgshopException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;


/** 
* @author 作者:SongYinglong
* @version 创建时间：2020年1月10日 下午2:07:42
* 类功能说明  全局异常处理类  ControllerAdvice注解  根据 springmvc.xml文件中的component-scan base-package下扫描的包进行拦截 如果有异常则交给该类处理
*/
@ControllerAdvice
public class GlobalExceptionHandler {
	
	/**
	 * 
	 * @Title: GlobalAjaxException
	 * @Description: ajax异常处理
	 * @param globalAjaxException
	 * @return
	 * @return: Result
	 */
	@ResponseBody
	@ExceptionHandler(value = {HgshopAjaxException.class})
	public Result GlobalAjaxException(HgshopAjaxException globalAjaxException) {
		return ResultUtil.error(globalAjaxException.getCode(), globalAjaxException.getMessage());
	}

	/**
	 * 
	 * @Title: GlobalExceptionHandler
	 * @Description: 普通请求时 发生的异常处理
	 * @param hgshopException
	 * @param request
	 * @return
	 * @return: String
	 */
	@ExceptionHandler(value = {HgshopException.class})
	public String GlobalExceptionHandler(HgshopException hgshopException, HttpServletRequest request) {
		request.setAttribute("message", hgshopException.getMessage());
		return request.getRequestURI();
	}
	
	/**
	 * 
	 * @Title: GlobalExceptionHandler
	 * @Description: 除自定义异常以外产生的异常
	 * @param exception
	 * @param request
	 * @return
	 * @return: String
	 */
	public String GlobalExceptionHandler(Exception exception,HttpServletRequest request) {
		System.err.println(exception.getMessage());
		request.setAttribute("message", exception.getMessage());
		return request.getRequestURI();
	}
}
