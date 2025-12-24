<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>浏览日志</title>
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
        <h2>客户浏览日志 - ${customer.username}</h2>
        <div class="admin-actions">
            <a href="/admin/customer/detail?id=${customer.id}" class="btn">返回客户详情</a>
            <a href="/admin/customer/list" class="btn">返回客户列表</a>
        </div>
        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>商品名称</th>
                    <th>商品价格</th>
                    <th>浏览时间</th>
                    <th>IP地址</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="log" items="${browseLogs}">
                    <tr>
                        <td>${log.id}</td>
                        <td>
                            <c:if test="${log.product != null}">
                                <a href="/product/detail?id=${log.product.id}" target="_blank">${log.product.name}</a>
                            </c:if>
                            <c:if test="${log.product == null}">
                                商品已删除
                            </c:if>
                        </td>
                        <td>
                            <c:if test="${log.product != null}">
                                ¥${log.product.price}
                            </c:if>
                            <c:if test="${log.product == null}">
                                -
                            </c:if>
                        </td>
                        <td>
                            <fmt:formatDate value="${log.browseTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                        </td>
                        <td>${log.ipAddress != null ? log.ipAddress : '-'}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty browseLogs}">
                    <tr>
                        <td colspan="5" style="text-align: center;">暂无浏览记录</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</body>
</html>

