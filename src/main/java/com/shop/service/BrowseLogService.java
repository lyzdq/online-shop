package com.shop.service;

import com.shop.entity.BrowseLog;

import java.util.List;

public interface BrowseLogService {
    boolean addBrowseLog(BrowseLog browseLog);
    List<BrowseLog> getBrowseLogsByUserId(Integer userId);
    List<BrowseLog> getBrowseLogsByProductId(Integer productId);
    List<BrowseLog> getAllBrowseLogs();
    List<BrowseLog> getBrowseLogsByUserIdWithProduct(Integer userId);
}

