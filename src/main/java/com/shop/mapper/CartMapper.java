package com.shop.mapper;

import com.shop.entity.Cart;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CartMapper {
    List<Cart> findByUserId(@Param("userId") Integer userId);
    Cart findByUserIdAndProductId(@Param("userId") Integer userId, @Param("productId") Integer productId);
    int insert(Cart cart);
    int update(Cart cart);
    int delete(@Param("id") Integer id);
    int deleteByUserId(@Param("userId") Integer userId);
}





