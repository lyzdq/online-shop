package com.shop.service.impl;

import com.shop.entity.Product;
import com.shop.mapper.ProductMapper;
import com.shop.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class ProductServiceImpl implements ProductService {
    
    @Autowired
    private ProductMapper productMapper;

    @Override
    public List<Product> getAllProducts() {
        return productMapper.findAll();
    }

    @Override
    public List<Product> getProductsByCategory(String category) {
        return productMapper.findByCategory(category);
    }

    @Override
    public List<Product> searchProducts(String keyword) {
        return productMapper.searchByName(keyword);
    }

    @Override
    public Product getProductById(Integer id) {
        return productMapper.findById(id);
    }

    @Override
    public boolean addProduct(Product product) {
        if (product.getStatus() == null) {
            product.setStatus(1);
        }
        return productMapper.insert(product) > 0;
    }

    @Override
    public boolean updateProduct(Product product) {
        return productMapper.update(product) > 0;
    }

    @Override
    public boolean deleteProduct(Integer id) {
        return productMapper.delete(id) > 0;
    }
}





