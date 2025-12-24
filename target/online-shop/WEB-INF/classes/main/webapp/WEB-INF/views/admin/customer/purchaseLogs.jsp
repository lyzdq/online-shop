<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>购买日志</title>
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
        <h2>客户购买日志 - ${customer.username}</h2>
        <div class="admin-actions">
            <a href="/admin/customer/detail?id=${customer.id}" class="btn">返回客户详情</a>
            <a href="/admin/customer/list" class="btn">返回客户列表</a>
        </div>
        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>订单号</th>
                    <th>商品名称</th>
                    <th>商品价格</th>
                    <th>购买数量</th>
                    <th>小计</th>
                    <th>购买时间</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="log" items="${purchaseLogs}">
                    <tr>
                        <td>${log.id}</td>
                        <td>
                            <c:if test="${log.order != null}">
                                <a href="/admin/order/detail?id=${log.order.id}" target="_blank">${log.order.orderNo}</a>
                            </c:if>
                            <c:if test="${log.order == null}">
                                ${log.orderId}
                            </c:if>
                        </td>
                        <td>
                            <c:if test="${log.product != null}">
                                <a href="/product/detail?id=${log.product.id}" target="_blank">${log.productName}</a>
                            </c:if>
                            <c:if test="${log.product == null}">
                                ${log.productName}
                            </c:if>
                        </td>
                        <td>¥${log.productPrice}</td>
                        <td>${log.quantity}</td>
                        <td>¥${log.subtotal}</td>
                        <td>
                            <fmt:formatDate value="${log.purchaseTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty purchaseLogs}">
                    <tr>
                        <td colspan="7" style="text-align: center;">暂无购买记录</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</body>
</html>

