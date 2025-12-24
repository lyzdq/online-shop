package com.shop.controller;

import com.shop.entity.User;
import com.shop.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/user")
public class UserController {
    
    @Autowired
    private UserService userService;

    @RequestMapping(value = "/login", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> login(String username, String password, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = userService.login(username, password);
        if (user != null) {
            session.setAttribute("user", user);
            result.put("success", true);
            result.put("message", "登录成功");
            result.put("role", user.getRole());
        } else {
            result.put("success", false);
            result.put("message", "用户名或密码错误");
        }
        return result;
    }

    @RequestMapping(value = "/register", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> register(String username, String password, String email, 
                                       String phone, String address) {
        Map<String, Object> result = new HashMap<>();
        
        // 参数验证
        if (username == null || username.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "用户名不能为空");
            return result;
        }
        if (password == null || password.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "密码不能为空");
            return result;
        }
        if (email == null || email.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "邮箱不能为空");
            return result;
        }
        
        // 创建User对象
        User user = new User();
        user.setUsername(username.trim());
        user.setPassword(password);
        user.setEmail(email.trim());
        if (phone != null && !phone.trim().isEmpty()) {
            user.setPhone(phone.trim());
        }
        if (address != null && !address.trim().isEmpty()) {
            user.setAddress(address.trim());
        }
        
        if (userService.register(user)) {
            result.put("success", true);
            result.put("message", "注册成功");
        } else {
            result.put("success", false);
            result.put("message", "注册失败，用户名可能已存在");
        }
        return result;
    }

    @RequestMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/index.jsp";
    }

    @RequestMapping("/info")
    @ResponseBody
    public Map<String, Object> getUserInfo(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");
        if (user != null) {
            user = userService.findById(user.getId());
            result.put("success", true);
            result.put("user", user);
        } else {
            result.put("success", false);
            result.put("message", "未登录");
        }
        return result;
    }

    @RequestMapping(value = "/update", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> updateUser(User user, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User sessionUser = (User) session.getAttribute("user");
        if (sessionUser == null) {
            result.put("success", false);
            result.put("message", "未登录");
            return result;
        }
        user.setId(sessionUser.getId());
        if (userService.updateUser(user)) {
            sessionUser = userService.findById(sessionUser.getId());
            session.setAttribute("user", sessionUser);
            result.put("success", true);
            result.put("message", "更新成功");
        } else {
            result.put("success", false);
            result.put("message", "更新失败");
        }
        return result;
    }
}

