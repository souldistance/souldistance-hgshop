package com.songyinglong.hgshop.service;


import com.github.pagehelper.PageInfo;
import com.songyinglong.hgshop.entity.User;
import com.songyinglong.hgshop.exception.HgshopAjaxException;
import com.songyinglong.hgshop.exception.HgshopException;

import java.util.List;
import java.util.Map;

/**
 * @author 作者:SongYinglong
 * @version 创建时间：2020年1月10日 下午2:07:42
 * 类功能说明
 */
public interface UserService {

    /**
     *
     * @Title: selectByExample
     * @Description: 查询用户列表
     * @param user
     * @param pageNum
     * @param pageSize
     * @return
     * @return: PageInfo<U>
     */
    PageInfo<User> selectByExample(User user, int pageNum, int pageSize);

    /**
     * 修改用户状态
     * @Title: updateUsers
     * @Description: 修改用户状态
     * @param user
     * @return
     * @return: boolean
     */
    boolean updateUsers(User user);

    /**
     * 根据条件查询用户
     * @Title: selectByPrimaryKey
     * @Description: 根据条件查询用户
     * @param user
     * @return
     * @return: List<U>
     */
    List<User> selectByExample(User user);

    /**
     *   添加用户(注册用户)
     * @Title: insertSelective
     * @Description: 添加用户(注册用户)
     * @param user
     * @return
     * @return: int
     */
    boolean insertSelective(User user);

    /**
     *
     * @Title: selectByUsername
     * @Description: 根据用户名查询用户
     * @param user
     * @return
     * @return: U
     */
    User selectByUsername(User user);

    /**
     *   登录功能
     * @Title: login
     * @Description: 登录功能
     * @param user
     * @return
     * @return: U
     */
    User login(User user) throws HgshopAjaxException, HgshopException, Exception;





    /**
     *  检查用户名 手机号 邮箱 是否存在
     * @param param
     * @param type
     * @return
     */
    boolean check(String param, Integer type);

    boolean register(User user);

    /**
     *  普通用户登陆功能
     * @param name
     * @param password
     * @return
     */
    Map<String, Object> login(String name, String password);

    Map<String, Object> getUserByToken(String token);

    void logout(String token);
}
