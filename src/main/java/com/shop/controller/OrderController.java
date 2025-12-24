package com.shop.controller;

import com.shop.entity.Order;
import com.shop.entity.User;
import com.shop.service.OrderService;
import com.shop.util.EmailUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/order")
public class OrderController {
    
    @Autowired
    private OrderService orderService;
    
    @Autowired
    private EmailUtil emailUtil;

    @RequestMapping("/list")
    public String list(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login.jsp";
        }
        List<Order> orders = orderService.getOrdersByUserId(user.getId());
        model.addAttribute("orders", orders);
        return "order/list";
    }

    @RequestMapping("/detail")
    public String detail(Integer id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login.jsp";
        }
        Order order = orderService.getOrderById(id);
        if (order == null || !order.getUserId().equals(user.getId())) {
            return "redirect:/order/list";
        }
        model.addAttribute("order", order);
        return "order/detail";
    }

    @RequestMapping(value = "/create", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> create(String address, String phone, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            return result;
        }
        String orderNo = orderService.createOrder(user.getId(), address, phone);
        if (orderNo != null) {
            // 更新订单状态为已付款（模拟付款）
            Order order = orderService.getOrderByOrderNo(orderNo);
            orderService.updateOrderStatus(order.getId(), "paid");
            
            result.put("success", true);
            result.put("message", "订单创建成功");
            result.put("orderNo", orderNo);
        } else {
            result.put("success", false);
            result.put("message", "订单创建失败，购物车可能为空");
        }
        return result;
    }

    @RequestMapping(value = "/pay", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> pay(Integer orderId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            return result;
        }
        Order order = orderService.getOrderById(orderId);
        if (order == null || !order.getUserId().equals(user.getId())) {
            result.put("success", false);
            result.put("message", "订单不存在");
            return result;
        }
        if (orderService.updateOrderStatus(orderId, "paid")) {
            result.put("success", true);
            result.put("message", "付款成功");
        } else {
            result.put("success", false);
            result.put("message", "付款失败");
        }
        return result;
    }
}





