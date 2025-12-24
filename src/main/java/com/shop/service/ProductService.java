package com.shop.service;

import com.shop.entity.Product;

import java.util.List;

public interface ProductService {
    List<Product> getAllProducts();
    List<Product> getProductsByCategory(String category);
    List<Product> searchProducts(String keyword);
    Product getProductById(Integer id);
    boolean addProduct(Product product);
    boolean updateProduct(Product product);
    boolean deleteProduct(Integer id);
}





