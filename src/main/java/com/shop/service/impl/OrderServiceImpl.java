package com.shop.service.impl;

import com.shop.entity.*;
import com.shop.mapper.*;
import com.shop.service.OrderService;
import com.shop.service.PurchaseLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Service
@Transactional
public class OrderServiceImpl implements OrderService {
    
    @Autowired
    private OrderMapper orderMapper;
    
    @Autowired
    private OrderItemMapper orderItemMapper;
    
    @Autowired
    private CartMapper cartMapper;
    
    @Autowired
    private ProductMapper productMapper;

    @Autowired
    private UserMapper userMapper;
    
    @Autowired
    private PurchaseLogService purchaseLogService;

    @Override
    public List<Order> getOrdersByUserId(Integer userId) {
        List<Order> orders = orderMapper.findByUserId(userId);
        for (Order order : orders) {
            order.setOrderItems(orderItemMapper.findByOrderId(order.getId()));
        }
        return orders;
    }

    @Override
    public Order getOrderById(Integer id) {
        Order order = orderMapper.findById(id);
        if (order != null) {
            order.setOrderItems(orderItemMapper.findByOrderId(id));

            User user = userMapper.findById(order.getUserId());
            order.setUser(user);
        }
        return order;
    }

    @Override
    public Order getOrderByOrderNo(String orderNo) {
        Order order = orderMapper.findByOrderNo(orderNo);
        if (order != null) {
            order.setOrderItems(orderItemMapper.findByOrderId(order.getId()));

            User user = userMapper.findById(order.getUserId());
            order.setUser(user);
        }
        return order;
    }

    @Override
    public String createOrder(Integer userId, String address, String phone) {
        // 获取购物车
        List<Cart> cartItems = cartMapper.findByUserId(userId);
        if (cartItems == null || cartItems.isEmpty()) {
            return null;
        }
        
        // 计算总金额
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (Cart cart : cartItems) {
            if (cart.getProduct() != null) {
                BigDecimal price = cart.getProduct().getPrice();
                Integer quantity = cart.getQuantity();
                totalAmount = totalAmount.add(price.multiply(new BigDecimal(quantity)));
            }
        }
        
        // 生成订单号
        String orderNo = generateOrderNo();
        
        // 创建订单
        Order order = new Order();
        order.setOrderNo(orderNo);
        order.setUserId(userId);
        order.setTotalAmount(totalAmount);
        order.setStatus("pending");
        order.setAddress(address);
        order.setPhone(phone);
        
        orderMapper.insert(order);
        
        // 创建订单详情
        for (Cart cart : cartItems) {
            if (cart.getProduct() != null) {
                OrderItem item = new OrderItem();
                item.setOrderId(order.getId());
                item.setProductId(cart.getProductId());
                item.setProductName(cart.getProduct().getName());
                item.setProductPrice(cart.getProduct().getPrice());
                item.setQuantity(cart.getQuantity());
                item.setSubtotal(cart.getProduct().getPrice().multiply(new BigDecimal(cart.getQuantity())));
                
                orderItemMapper.insert(item);
                
                // 记录购买日志
                PurchaseLog purchaseLog = new PurchaseLog();
                purchaseLog.setUserId(userId);
                purchaseLog.setOrderId(order.getId());
                purchaseLog.setProductId(cart.getProductId());
                purchaseLog.setProductName(cart.getProduct().getName());
                purchaseLog.setProductPrice(cart.getProduct().getPrice());
                purchaseLog.setQuantity(cart.getQuantity());
                purchaseLog.setSubtotal(cart.getProduct().getPrice().multiply(new BigDecimal(cart.getQuantity())));
                purchaseLogService.addPurchaseLog(purchaseLog);
                
                // 减少库存
                Product product = productMapper.findById(cart.getProductId());
                if (product != null) {
                    product.setStock(product.getStock() - cart.getQuantity());
                    productMapper.update(product);
                }
            }
        }
        
        // 清空购物车
        cartMapper.deleteByUserId(userId);
        
        return orderNo;
    }

    @Override
    public boolean updateOrderStatus(Integer orderId, String status) {
        Order order = new Order();
        order.setId(orderId);
        order.setStatus(status);
        return orderMapper.update(order) > 0;
    }

    @Override
    public List<Order> getAllOrders() {
        List<Order> orders = orderMapper.findAll();
        for (Order order : orders) {
            order.setOrderItems(orderItemMapper.findByOrderId(order.getId()));
        }
        return orders;
    }

    @Override
    public List<Order> getOrdersByStatus(String status) {
        List<Order> orders = orderMapper.findByStatus(status);
        for (Order order : orders) {
            order.setOrderItems(orderItemMapper.findByOrderId(order.getId()));
        }
        return orders;
    }

    @Override
    public boolean shipOrder(Integer orderId) {
        return updateOrderStatus(orderId, "shipped");
    }
    
    private String generateOrderNo() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String dateStr = sdf.format(new Date());
        String uuid = UUID.randomUUID().toString().replace("-", "").substring(0, 8);
        return "ORD" + dateStr + uuid;
    }
}





