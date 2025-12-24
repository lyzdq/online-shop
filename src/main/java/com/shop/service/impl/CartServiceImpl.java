package com.shop.service.impl;

import com.shop.entity.Cart;
import com.shop.mapper.CartMapper;
import com.shop.mapper.ProductMapper;
import com.shop.entity.Product;
import com.shop.service.CartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class CartServiceImpl implements CartService {
    
    @Autowired
    private CartMapper cartMapper;
    
    @Autowired
    private ProductMapper productMapper;

    @Override
    public List<Cart> getCartByUserId(Integer userId) {
        return cartMapper.findByUserId(userId);
    }

    @Override
    public boolean addToCart(Integer userId, Integer productId, Integer quantity) {
        Product product = productMapper.findById(productId);
        if (product == null || product.getStock() < quantity) {
            return false;
        }
        
        Cart existCart = cartMapper.findByUserIdAndProductId(userId, productId);
        if (existCart != null) {
            existCart.setQuantity(existCart.getQuantity() + quantity);
            return cartMapper.update(existCart) > 0;
        } else {
            Cart cart = new Cart();
            cart.setUserId(userId);
            cart.setProductId(productId);
            cart.setQuantity(quantity);
            return cartMapper.insert(cart) > 0;
        }
    }

    @Override
    public boolean updateCartQuantity(Integer cartId, Integer quantity) {
        Cart cart = new Cart();
        cart.setId(cartId);
        cart.setQuantity(quantity);
        return cartMapper.update(cart) > 0;
    }

    @Override
    public boolean removeFromCart(Integer cartId) {
        return cartMapper.delete(cartId) > 0;
    }

    @Override
    public boolean clearCart(Integer userId) {
        return cartMapper.deleteByUserId(userId) > 0;
    }
}





