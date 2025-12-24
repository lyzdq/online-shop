-- 创建数据库
CREATE DATABASE IF NOT EXISTS online_shop DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE online_shop;

-- 用户表
CREATE TABLE IF NOT EXISTS `user` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
  `password` VARCHAR(255) NOT NULL COMMENT '密码',
  `email` VARCHAR(100) NOT NULL COMMENT '邮箱',
  `phone` VARCHAR(20) DEFAULT NULL COMMENT '电话',
  `address` VARCHAR(255) DEFAULT NULL COMMENT '地址',
  `role` VARCHAR(20) DEFAULT 'customer' COMMENT '角色：customer/admin',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 商品表
CREATE TABLE IF NOT EXISTS `product` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL COMMENT '商品名称',
  `description` TEXT COMMENT '商品描述',
  `price` DECIMAL(10,2) NOT NULL COMMENT '价格',
  `stock` INT(11) NOT NULL DEFAULT 0 COMMENT '库存',
  `category` VARCHAR(50) DEFAULT NULL COMMENT '分类',
  `image` VARCHAR(255) DEFAULT NULL COMMENT '图片路径',
  `status` TINYINT(1) DEFAULT 1 COMMENT '状态：1-上架，0-下架',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品表';

-- 购物车表
CREATE TABLE IF NOT EXISTS `cart` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_id` INT(11) NOT NULL COMMENT '用户ID',
  `product_id` INT(11) NOT NULL COMMENT '商品ID',
  `quantity` INT(11) NOT NULL DEFAULT 1 COMMENT '数量',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_product_id` (`product_id`),
  CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_cart_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='购物车表';

-- 订单表
CREATE TABLE IF NOT EXISTS `order` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `order_no` VARCHAR(50) NOT NULL UNIQUE COMMENT '订单号',
  `user_id` INT(11) NOT NULL COMMENT '用户ID',
  `total_amount` DECIMAL(10,2) NOT NULL COMMENT '总金额',
  `status` VARCHAR(20) DEFAULT 'pending' COMMENT '状态：pending-待付款，paid-已付款，shipped-已发货，completed-已完成，cancelled-已取消',
  `address` VARCHAR(255) NOT NULL COMMENT '收货地址',
  `phone` VARCHAR(20) NOT NULL COMMENT '联系电话',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_order_no` (`order_no`),
  CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- 订单详情表
CREATE TABLE IF NOT EXISTS `order_item` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `order_id` INT(11) NOT NULL COMMENT '订单ID',
  `product_id` INT(11) NOT NULL COMMENT '商品ID',
  `product_name` VARCHAR(100) NOT NULL COMMENT '商品名称',
  `product_price` DECIMAL(10,2) NOT NULL COMMENT '商品价格',
  `quantity` INT(11) NOT NULL COMMENT '数量',
  `subtotal` DECIMAL(10,2) NOT NULL COMMENT '小计',
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_product_id` (`product_id`),
  CONSTRAINT `fk_order_item_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_order_item_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单详情表';

-- 浏览日志表
CREATE TABLE IF NOT EXISTS `browse_log` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_id` INT(11) DEFAULT NULL COMMENT '用户ID（未登录用户为NULL）',
  `product_id` INT(11) NOT NULL COMMENT '商品ID',
  `browse_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '浏览时间',
  `ip_address` VARCHAR(50) DEFAULT NULL COMMENT 'IP地址',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_browse_time` (`browse_time`),
  CONSTRAINT `fk_browse_log_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_browse_log_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='浏览日志表';

-- 购买日志表
CREATE TABLE IF NOT EXISTS `purchase_log` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_id` INT(11) NOT NULL COMMENT '用户ID',
  `order_id` INT(11) NOT NULL COMMENT '订单ID',
  `product_id` INT(11) NOT NULL COMMENT '商品ID',
  `product_name` VARCHAR(100) NOT NULL COMMENT '商品名称',
  `product_price` DECIMAL(10,2) NOT NULL COMMENT '商品价格',
  `quantity` INT(11) NOT NULL COMMENT '购买数量',
  `subtotal` DECIMAL(10,2) NOT NULL COMMENT '小计',
  `purchase_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '购买时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_purchase_time` (`purchase_time`),
  CONSTRAINT `fk_purchase_log_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_purchase_log_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_purchase_log_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='购买日志表';

-- 插入测试数据
-- 插入管理员用户（密码：admin123）
INSERT INTO `user` (`username`, `password`, `email`, `role`) VALUES
('admin', 'admin123', 'admin@shop.com', 'admin');

-- 插入测试商品
INSERT INTO `product` (`name`, `description`, `price`, `stock`, `category`, `image`) VALUES
('iPhone 17', '最新款iPhone手机', 5999.00, 100, '手机', '/images/iphone17.jpg'),
('MacBook Pro', '苹果笔记本电脑', 12999.00, 50, '电脑', '/images/macbook.jpg'),
('AirPods Pro', '无线蓝牙耳机', 1899.00, 200, '配件', '/images/airpods.jpg'),
('iPad Air', '平板电脑', 4399.00, 80, '平板', '/images/ipad.jpg'),
('Apple Watch', '智能手表', 2999.00, 150, '手表', '/images/watch.jpg');