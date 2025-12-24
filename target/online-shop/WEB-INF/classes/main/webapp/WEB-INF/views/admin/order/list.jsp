<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单管理</title>
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
        <h2>订单管理</h2>
        <table class="admin-table">
            <thead>
                <tr>
                    <th>订单号</th>
                    <th>用户ID</th>
                    <th>总金额</th>
                    <th>状态</th>
                    <th>创建时间</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="order" items="${orders}">
                    <tr>
                        <td>${order.orderNo}</td>
                        <td>${order.userId}</td>
                        <td>¥${order.totalAmount}</td>
                        <td>
                            <c:choose>
                                <c:when test="${order.status == 'pending'}">待付款</c:when>
                                <c:when test="${order.status == 'paid'}">已付款</c:when>
                                <c:when test="${order.status == 'shipped'}">已发货</c:when>
                                <c:when test="${order.status == 'completed'}">已完成</c:when>
                                <c:when test="${order.status == 'cancelled'}">已取消</c:when>
                                <c:otherwise>${order.status}</c:otherwise>
                            </c:choose>
                        </td>
                        <td>${order.createTime}</td>
                        <td>
                            <a href="/admin/order/detail?id=${order.id}">查看详情</a>
                            <c:if test="${order.status == 'paid'}">
                                | <a href="javascript:void(0)" onclick="shipOrder(${order.id})">发货</a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <script src="${pageContext.request.contextPath}/js/common.js"></script>
    <script>
        function shipOrder(orderId) {
            if (confirm('确认发货？')) {
                fetch('/admin/order/ship', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'orderId=' + orderId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert(data.message);
                        location.reload();
                    } else {
                        alert(data.message);
                    }
                });
            }
        }
    </script>
</body>
</html>

