package com.shop.service.impl;

import com.shop.entity.PurchaseLog;
import com.shop.mapper.PurchaseLogMapper;
import com.shop.service.PurchaseLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class PurchaseLogServiceImpl implements PurchaseLogService {
    
    @Autowired
    private PurchaseLogMapper purchaseLogMapper;

    @Override
    public boolean addPurchaseLog(PurchaseLog purchaseLog) {
        return purchaseLogMapper.insert(purchaseLog) > 0;
    }

    @Override
    public List<PurchaseLog> getPurchaseLogsByUserId(Integer userId) {
        return purchaseLogMapper.findByUserId(userId);
    }

    @Override
    public List<PurchaseLog> getPurchaseLogsByOrderId(Integer orderId) {
        return purchaseLogMapper.findByOrderId(orderId);
    }

    @Override
    public List<PurchaseLog> getAllPurchaseLogs() {
        return purchaseLogMapper.findAll();
    }

    @Override
    public List<PurchaseLog> getPurchaseLogsByUserIdWithProduct(Integer userId) {
        return purchaseLogMapper.findByUserIdWithProduct(userId);
    }
}

