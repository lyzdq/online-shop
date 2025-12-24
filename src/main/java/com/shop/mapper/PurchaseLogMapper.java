package com.shop.mapper;

import com.shop.entity.PurchaseLog;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface PurchaseLogMapper {
    int insert(PurchaseLog purchaseLog);
    List<PurchaseLog> findByUserId(@Param("userId") Integer userId);
    List<PurchaseLog> findByOrderId(@Param("orderId") Integer orderId);
    List<PurchaseLog> findAll();
    List<PurchaseLog> findByUserIdWithProduct(@Param("userId") Integer userId);
}

