package com.shop.service;

import com.shop.entity.User;
import java.util.List;

public interface UserService {
    User login(String username, String password);
    boolean register(User user);
    User findById(Integer id);
    boolean updateUser(User user);
    List<User> getAllCustomers();
}





