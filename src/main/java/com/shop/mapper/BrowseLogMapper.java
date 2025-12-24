package com.shop.mapper;

import com.shop.entity.BrowseLog;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface BrowseLogMapper {
    int insert(BrowseLog browseLog);
    List<BrowseLog> findByUserId(@Param("userId") Integer userId);
    List<BrowseLog> findByProductId(@Param("productId") Integer productId);
    List<BrowseLog> findAll();
    List<BrowseLog> findByUserIdWithProduct(@Param("userId") Integer userId);
}

