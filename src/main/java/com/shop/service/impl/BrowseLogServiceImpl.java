package com.shop.service.impl;

import com.shop.entity.BrowseLog;
import com.shop.mapper.BrowseLogMapper;
import com.shop.service.BrowseLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class BrowseLogServiceImpl implements BrowseLogService {
    
    @Autowired
    private BrowseLogMapper browseLogMapper;

    @Override
    public boolean addBrowseLog(BrowseLog browseLog) {
        return browseLogMapper.insert(browseLog) > 0;
    }

    @Override
    public List<BrowseLog> getBrowseLogsByUserId(Integer userId) {
        return browseLogMapper.findByUserId(userId);
    }

    @Override
    public List<BrowseLog> getBrowseLogsByProductId(Integer productId) {
        return browseLogMapper.findByProductId(productId);
    }

    @Override
    public List<BrowseLog> getAllBrowseLogs() {
        return browseLogMapper.findAll();
    }

    @Override
    public List<BrowseLog> getBrowseLogsByUserIdWithProduct(Integer userId) {
        return browseLogMapper.findByUserIdWithProduct(userId);
    }
}

