<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单详情</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="header">
        <div class="container">
            <h1>管理后台</h1>
            <div class="user-info">
                欢迎，${sessionScope.user.username} | 
                <a href="/admin/order/list">订单管理</a> | 
                <a href="/index.jsp">返回前台</a> | 
                <a href="/user/logout">退出</a>
            </div>
        </div>
    </div>

    <div class="container">
        <h2>订单详情</h2>
        <div class="order-detail">
            <p><strong>订单号：</strong>${order.orderNo}</p>
            <p><strong>用户ID：</strong>${order.userId}</p>
            <p><strong>总金额：</strong>¥${order.totalAmount}</p>
            <p><strong>状态：</strong>
                <c:choose>
                    <c:when test="${order.status == 'pending'}">待付款</c:when>
                    <c:when test="${order.status == 'paid'}">已付款</c:when>
                    <c:when test="${order.status == 'shipped'}">已发货</c:when>
                    <c:when test="${order.status == 'completed'}">已完成</c:when>
                    <c:when test="${order.status == 'cancelled'}">已取消</c:when>
                    <c:otherwise>${order.status}</c:otherwise>
                </c:choose>
            </p>
            <p><strong>收货地址：</strong>${order.address}</p>
            <p><strong>联系电话：</strong>${order.phone}</p>
            <p><strong>创建时间：</strong>${order.createTime}</p>
        </div>

        <h3>订单商品</h3>
        <table class="order-item-table">
            <thead>
                <tr>
                    <th>商品名称</th>
                    <th>单价</th>
                    <th>数量</th>
                    <th>小计</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${order.orderItems}">
                    <tr>
                        <td>${item.productName}</td>
                        <td>¥${item.productPrice}</td>
                        <td>${item.quantity}</td>
                        <td>¥${item.subtotal}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <c:if test="${order.status == 'paid'}">
            <button onclick="shipOrder(${order.id})">发货</button>
        </c:if>
        <a href="/admin/order/list">返回订单列表</a>
    </div>

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

