package com.shop.service;

import com.shop.entity.Order;

import java.util.List;

public interface OrderService {
    List<Order> getOrdersByUserId(Integer userId);
    Order getOrderById(Integer id);
    Order getOrderByOrderNo(String orderNo);
    String createOrder(Integer userId, String address, String phone);
    boolean updateOrderStatus(Integer orderId, String status);
    List<Order> getAllOrders();
    List<Order> getOrdersByStatus(String status);
    boolean shipOrder(Integer orderId);
}





