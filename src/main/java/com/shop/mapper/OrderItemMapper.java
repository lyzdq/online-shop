package com.shop.mapper;

import com.shop.entity.OrderItem;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface OrderItemMapper {
    List<OrderItem> findByOrderId(@Param("orderId") Integer orderId);
    int insert(OrderItem orderItem);
    int insertBatch(@Param("items") List<OrderItem> items);
}





