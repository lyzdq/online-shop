package com.shop.mapper;

import com.shop.entity.Product;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ProductMapper {
    List<Product> findAll();
    List<Product> findByCategory(@Param("category") String category);
    List<Product> searchByName(@Param("keyword") String keyword);
    Product findById(@Param("id") Integer id);
    int insert(Product product);
    int update(Product product);
    int delete(@Param("id") Integer id);
}





