<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>客户详情</title>
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
                <a href="/admin/statistics">销售统计</a> | 
                <a href="/index.jsp">返回前台</a> | 
                <a href="/user/logout">退出</a>
            </div>
        </div>
    </div>

    <div class="container">
        <h2>客户详情</h2>
        <div class="customer-detail">
            <table class="detail-table">
                <tr>
                    <th>用户ID：</th>
                    <td>${customer.id}</td>
                </tr>
                <tr>
                    <th>用户名：</th>
                    <td>${customer.username}</td>
                </tr>
                <tr>
                    <th>邮箱：</th>
                    <td>${customer.email}</td>
                </tr>
                <tr>
                    <th>电话：</th>
                    <td>${customer.phone != null ? customer.phone : '-'}</td>
                </tr>
                <tr>
                    <th>地址：</th>
                    <td>${customer.address != null ? customer.address : '-'}</td>
                </tr>
                <tr>
                    <th>注册时间：</th>
                    <td><fmt:formatDate value="${customer.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                </tr>
            </table>
            <div class="admin-actions" style="margin-top: 20px;">
                <a href="/admin/customer/browseLogs?userId=${customer.id}" class="btn">查看浏览日志</a>
                <a href="/admin/customer/purchaseLogs?userId=${customer.id}" class="btn">查看购买日志</a>
                <a href="/admin/customer/list" class="btn">返回列表</a>
            </div>
        </div>
    </div>
</body>
</html>

