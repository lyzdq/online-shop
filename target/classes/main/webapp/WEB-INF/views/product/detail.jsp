<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品详情</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="header">
        <div class="container">
            <h1>在线购物网站</h1>
            <div class="user-info">
                <c:if test="${sessionScope.user == null}">
                    <a href="/user/login.jsp">登录</a> | 
                    <a href="/user/register.jsp">注册</a>
                </c:if>
                <c:if test="${sessionScope.user != null}">
                    欢迎，${sessionScope.user.username} | 
                    <a href="/cart/list">购物车</a> | 
                    <a href="/order/list">我的订单</a> | 
                    <a href="/user/logout">退出</a>
                </c:if>
            </div>
        </div>
    </div>

    <div class="container">
        <a href="/index.jsp">返回首页</a>
        <div class="product-detail">
            <div class="product-image-large">
                <img src="${product.image != null ? product.image : '/images/default.jpg'}" alt="${product.name}">
            </div>
            <div class="product-detail-info">
                <h2>${product.name}</h2>
                <p class="price">¥${product.price}</p>
                <p class="stock">库存：${product.stock}</p>
                <p class="description">${product.description}</p>
                <div class="quantity-selector">
                    <label>数量：</label>
                    <input type="number" id="quantity" value="1" min="1" max="${product.stock}">
                </div>
                <button onclick="addToCart(${product.id})">加入购物车</button>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/common.js"></script>
    <script>
        function addToCart(productId) {
            const quantity = document.getElementById('quantity').value;
            addToCartWithQuantity(productId, quantity);
        }
    </script>
</body>
</html>

