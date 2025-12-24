package com.shop.service;

import com.shop.entity.PurchaseLog;

import java.util.List;

public interface PurchaseLogService {
    boolean addPurchaseLog(PurchaseLog purchaseLog);
    List<PurchaseLog> getPurchaseLogsByUserId(Integer userId);
    List<PurchaseLog> getPurchaseLogsByOrderId(Integer orderId);
    List<PurchaseLog> getAllPurchaseLogs();
    List<PurchaseLog> getPurchaseLogsByUserIdWithProduct(Integer userId);
}

