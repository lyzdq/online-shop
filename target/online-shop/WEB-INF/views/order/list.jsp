<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的订单</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="header">
        <div class="container">
            <h1>在线购物网站</h1>
            <div class="user-info">
                欢迎，${sessionScope.user.username} | 
                <a href="/index.jsp">首页</a> | 
                <a href="/cart/list">购物车</a> | 
                <a href="/user/logout">退出</a>
            </div>
        </div>
    </div>

    <div class="container">
        <h2>我的订单</h2>
        <c:if test="${empty orders}">
            <p>暂无订单</p>
            <a href="/index.jsp">去购物</a>
        </c:if>
        <c:if test="${not empty orders}">
            <table class="order-table">
                <thead>
                    <tr>
                        <th>订单号</th>
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
                                <a href="/order/detail?id=${order.id}">查看详情</a>
                                <c:if test="${order.status == 'pending'}">
                                    | <a href="javascript:void(0)" onclick="payOrder(${order.id})">付款</a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>

    <script src="${pageContext.request.contextPath}/js/common.js"></script>
    <script>
        function payOrder(orderId) {
            if (confirm('确认付款？')) {
                fetch('/order/pay', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'orderId=' + orderId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('付款成功！');
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

