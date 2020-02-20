package com.songyinglong.hgshop.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.google.gson.Gson;
import com.songyinglong.common.utils.StringUtil;
import com.songyinglong.hgshop.entity.User;
import com.songyinglong.hgshop.entity.UserExample;
import com.songyinglong.hgshop.entity.UserExample.Criteria;
import com.songyinglong.hgshop.exception.HgshopAjaxException;
import com.songyinglong.hgshop.exception.HgshopException;
import com.songyinglong.hgshop.mapper.UserMapper;
import com.songyinglong.hgshop.service.UserService;
import com.songyinglong.hgshop.util.Md5Util;
import org.apache.dubbo.common.utils.StringUtils;
import org.apache.dubbo.config.annotation.Service;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.util.DigestUtils;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

/**
 * @author 作者:SongYinglong
 * @version 创建时间：2020年1月10日 下午2:07:42
 */
@Service
public class UserServiceImpl implements UserService {

    @Resource
    private UserMapper userMapper;

    @Resource
    private RedisTemplate<String, Object> redisTemplate;

    @Override
    public PageInfo<User> selectByExample(User user, int pageNum, int pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        System.out.println(111);
        UserExample userExample = new UserExample();
        if (user.getUsername() != null) {
            userExample.createCriteria().andUsernameLike("%" + user.getUsername() + "%");
        }
        List<User> users = userMapper.selectByExample(userExample);
        return new PageInfo<User>(users,5);
    }

    /**
     *
     * @Title: updateUsers
     * @Description: 修改用户状态
     * @param user
     * @return
     * @return: boolean
     */
    @Override
    public boolean updateUsers(User user) {
        try {
            return userMapper.updateByPrimaryKeySelective(user) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            throw new HgshopAjaxException(1,"修改失败");
        }

    }

    /**
     *
     * @Title: selectByPrimaryKey
     * @Description: 根据条件查询用户
     * @param user
     * @return
     * @return: List<User>
     */
    @Override
    public List<User> selectByExample(User user) {
        UserExample userExample = new UserExample();
        Criteria criteria = userExample.createCriteria();
        if (user.getUsername() != null) {
            criteria.andUsernameEqualTo(user.getUsername());
        }
        try {
            return userMapper.selectByExample(userExample);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("查询用户失败!");
        }
    }



    @Override
    public boolean insertSelective(User user) {
        // 如果用户为null. 说明没有传值
        if (null == user) {
            throw new HgshopException("用户名或密码必须输入");
        }
        if (!StringUtil.hasText(user.getUsername())) {
            throw new HgshopException("用户名不能为空!");
        }
        if (!(user.getUsername().length() >= 2 && user.getUsername().length() <= 6)) {
            throw new HgshopException("用户名长度为2-6之间!");
        }
        if (!user.getUsername().matches("^[\\u4e00-\\u94a5]{2,6}$")) {
            throw new HgshopException("用户名必须为中文!");
        }
        if (!StringUtil.hasText(user.getPassword())) {
            throw new HgshopException("密码不能为空!");
        }
        if (!(user.getPassword().length() >= 2 && user.getPassword().length() <= 10)) {
            throw new HgshopException("密码长度为2-10之间!");
        }
        user.setPassword(Md5Util.md5Encoding(user.getPassword()));
        user.setRole(1);
        return userMapper.insert(user) > 0;
    }

    @Override
    public User selectByUsername(User user) {

        return userMapper.selectByUsername(user);
    }


    @Override
    public User login(User user) throws HgshopAjaxException, HgshopException, Exception{
        // 如果用户为null. 说明没有传值
        if (null == user) {
            throw new HgshopAjaxException(1,"用户名或密码必须输入");
        }
        if (!StringUtil.hasText(user.getUsername())) {
            throw new HgshopAjaxException(2,"用户名不能为空!");
        }
        if (!StringUtil.hasText(user.getPassword())) {
            throw new HgshopAjaxException(3,"密码不能为空!");
        }
        User u = userMapper.selectByUsername(user);
        if(u==null) {
            throw new HgshopAjaxException(4,"没有该用户!");
        }
        if(!u.getPassword().equals(Md5Util.md5Encoding(user.getPassword()))) {
            throw new HgshopAjaxException(5,"密码错误!");
        }
        return u;
    }



    @Override
    public boolean check(String param, Integer type) {
        int count = userMapper.check(param, type);
        System.err.println(count);
        return count > 0;
    }


    @Override
    public boolean register(User user) {

        synchronized(this) {
            //1.校验check
            //2.注册

        }
        //激活状态：需要邮箱或手机号激活
        user.setState(0);
        user.setPassword(DigestUtils.md5DigestAsHex(user.getPassword().getBytes()));
        int count = userMapper.register(user);

        return count > 0;
    }

    @Override
    public Map<String, Object> login(String name, String password) {
        Map<String, Object> map = new HashMap<>();
        User user1 = userMapper.getUserBySearch(name);
        if (user1 != null) {
            password = DigestUtils.md5DigestAsHex(password.getBytes());
            if (user1.getPassword().equals(password)) {
                //session共享（使用redis替换session）
                String token = addUserToRedis(user1);
                map.put("code", "1000");
                map.put("msg", token);
            } else {
                map.put("code", "1002");
                map.put("msg", "密码不正确");
            }
        } else {
            map.put("code", "1001");
            map.put("msg", "用户名不正确");
        }
        return map;
    }

    private String addUserToRedis(User user) {
        user.setPassword(null);
        String token = UUID.randomUUID().toString();
        Gson gson = new Gson();
        redisTemplate.opsForValue().set("SESSION:" + token, gson.toJson(user), 3600, TimeUnit.SECONDS);
        return token;
    }

    @Override
    public Map<String, Object> getUserByToken(String token) {
        Map<String, Object> map = new HashMap<>();
        String json = (String) redisTemplate.opsForValue().get("SESSION:" + token);
        if (StringUtils.isBlank(json)) {
            map.put("code", "1003");
            map.put("data", "用户登录已过期");
        } else {
            redisTemplate.expire("SESSION:" + token, 3600, TimeUnit.SECONDS);
            Gson gson = new Gson();
            map.put("code", "1000");
            map.put("data", gson.fromJson(json, User.class));
        }
        return map;
    }

    @Override
    public void logout(String token) {
        redisTemplate.delete("SESSION:" + token);
    }
}