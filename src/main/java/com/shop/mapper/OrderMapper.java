package com.shop.mapper;

import com.shop.entity.Order;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface OrderMapper {
    List<Order> findByUserId(@Param("userId") Integer userId);
    Order findByOrderNo(@Param("orderNo") String orderNo);
    Order findById(@Param("id") Integer id);
    List<Order> findAll();
    int insert(Order order);
    int update(Order order);
    List<Order> findByStatus(@Param("status") String status);
}





