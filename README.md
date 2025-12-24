# 在线购物网站

## 学号：202330450832
## 姓名：赖芸

## 项目介绍
基于SSM（Spring + SpringMVC + MyBatis）框架的在线购物网站，包含用户管理、商品展示、购物车、订单管理等功能。

## 功能模块
- 用户模块：注册、登录、注销
- 商品模块：商品展示、搜索、分类浏览、详情查看
- 购物车模块：添加商品、修改数量、删除商品
- 订单模块：下单、付款、查看订单状态
- 后台管理：商品管理、订单管理、客户管理、销售统计

## 技术栈
- 后端：Spring 5.3.21 + SpringMVC + MyBatis 3.5.10
- 前端：JSP + JSTL + JavaScript + CSS
- 数据库：MySQL 8.0 / MariaDB
- 服务器：Tomcat 9
- 构建工具：Maven

## 部署说明
1. 导入数据库：执行 `schema.sql`
2. 修改配置：`src/main/resources/db.properties`
3. 构建项目：`mvn clean package`
4. 部署war包到Tomcat

## 测试账号
- 管理员：用户名 admin / 密码 admin123
- 普通用户：自行注册