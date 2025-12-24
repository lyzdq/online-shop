<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品管理</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="header">
        <div class="container">
            <h1>管理后台</h1>
            <div class="user-info">
                欢迎，${sessionScope.user.username} | 
                <a href="/admin/statistics">销售统计</a> | 
                <a href="/admin/order/list">订单管理</a> | 
                <a href="/admin/customer/list">客户管理</a> | 
                <a href="/index.jsp">返回前台</a> | 
                <a href="/user/logout">退出</a>
            </div>
        </div>
    </div>

    <div class="container">
        <h2>商品管理</h2>
        <div class="admin-actions">
            <a href="/admin/product/add" class="btn">添加商品</a>
        </div>
        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>商品名称</th>
                    <th>价格</th>
                    <th>库存</th>
                    <th>分类</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="product" items="${products}">
                    <tr>
                        <td>${product.id}</td>
                        <td>${product.name}</td>
                        <td>¥${product.price}</td>
                        <td>${product.stock}</td>
                        <td>${product.category}</td>
                        <td>${product.status == 1 ? '上架' : '下架'}</td>
                        <td>
                            <a href="/admin/product/edit?id=${product.id}">编辑</a> | 
                            <a href="javascript:void(0)" onclick="deleteProduct(${product.id})">删除</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <script src="${pageContext.request.contextPath}/js/common.js"></script>
    <script>
        function deleteProduct(id) {
            if (confirm('确定要删除这个商品吗？')) {
                fetch('/admin/product/delete', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'id=' + id
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('删除成功');
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

