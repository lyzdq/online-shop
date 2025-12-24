package com.shop.mapper;

import com.shop.entity.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserMapper {
    User findByUsername(@Param("username") String username);
    User findById(@Param("id") Integer id);
    int insert(User user);
    int update(User user);
    List<User> findAllCustomers();
}





