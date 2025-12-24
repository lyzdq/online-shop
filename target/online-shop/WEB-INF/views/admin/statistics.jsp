<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>销售统计</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="header">
        <div class="container">
            <h1>管理后台</h1>
            <div class="user-info">
                欢迎，${sessionScope.user.username} | 
                <a href="/admin/product/list">商品管理</a> | 
                <a href="/admin/order/list">订单管理</a> | 
                <a href="/admin/customer/list">客户管理</a> | 
                <a href="/index.jsp">返回前台</a> | 
                <a href="/user/logout">退出</a>
            </div>
        </div>
    </div>

    <div class="container">
        <h2>销售统计报表</h2>
        <div class="statistics">
            <div class="stat-item">
                <h3>总订单数</h3>
                <p class="stat-value">${totalOrders}</p>
            </div>
            <div class="stat-item">
                <h3>总销售额</h3>
                <p class="stat-value">¥${totalRevenue}</p>
            </div>
            <div class="stat-item">
                <h3>待付款订单</h3>
                <p class="stat-value">${pendingOrders}</p>
            </div>
            <div class="stat-item">
                <h3>已付款订单</h3>
                <p class="stat-value">${paidOrders}</p>
            </div>
            <div class="stat-item">
                <h3>已发货订单</h3>
                <p class="stat-value">${shippedOrders}</p>
            </div>
            <div class="stat-item">
                <h3>已完成订单</h3>
                <p class="stat-value">${completedOrders}</p>
            </div>
        </div>
    </div>
</body>
</html>

