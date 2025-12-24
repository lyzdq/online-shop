package com.shop.service;

import com.shop.entity.Cart;

import java.util.List;

public interface CartService {
    List<Cart> getCartByUserId(Integer userId);
    boolean addToCart(Integer userId, Integer productId, Integer quantity);
    boolean updateCartQuantity(Integer cartId, Integer quantity);
    boolean removeFromCart(Integer cartId);
    boolean clearCart(Integer userId);
}





