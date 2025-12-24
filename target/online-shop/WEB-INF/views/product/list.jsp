<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品列表</title>
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
        <div class="search-bar">
            <form action="/product/search" method="get" onsubmit="return handleSearch(this)">
                <input type="text" name="keyword" placeholder="搜索商品..." value="${keyword}" id="searchKeyword">
                <button type="submit">搜索</button>
                <button type="button" onclick="showAll()">显示全部</button>
            </form>
            <a href="/index.jsp">返回首页</a>
        </div>

        <c:if test="${category != null}">
            <h2>分类：${category}</h2>
        </c:if>

        <div class="product-list">
            <c:choose>
                <c:when test="${products != null && !empty products}">
                    <c:forEach var="product" items="${products}">
                        <div class="product-item">
                            <div class="product-image">
                                <img src="${product.image != null && product.image != '' ? product.image : '/images/default.jpg'}" alt="${product.name}">
                            </div>
                            <div class="product-info">
                                <h3><a href="/product/detail?id=${product.id}">${product.name}</a></h3>
                                <p class="description">${product.description}</p>
                                <p class="price">¥${product.price}</p>
                                <p class="stock">库存：${product.stock}</p>
                                <button onclick="addToCart(${product.id})">加入购物车</button>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p style="text-align: center; padding: 20px; color: #666;">暂无商品</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/common.js"></script>
    <script>
        // 页面加载时自动加载商品
        window.addEventListener('DOMContentLoaded', function() {
            var productList = document.querySelector('.product-list');
            var hasProducts = productList.querySelector('.product-item') !== null;
            var isEmptyMessage = productList.querySelector('p') && productList.querySelector('p').textContent.includes('暂无商品');
            
            // 如果没有商品数据，自动加载所有商品
            if (!hasProducts && isEmptyMessage) {
                loadAllProducts();
            }
        });
        
        // 加载所有商品
        function loadAllProducts() {
            fetch('/product/api/list')
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.data && data.data.length > 0) {
                        displayProducts(data.data);
                    } else {
                        document.querySelector('.product-list').innerHTML = 
                            '<p style="text-align: center; padding: 20px; color: #666;">暂无商品</p>';
                    }
                })
                .catch(error => {
                    console.error('加载商品失败:', error);
                });
        }
        
        // 显示商品列表
        function displayProducts(products) {
            var productList = document.querySelector('.product-list');
            var html = '';
            products.forEach(function(product) {
                var imageUrl = (product.image && product.image !== '') ? product.image : '/images/default.jpg';
                html += '<div class="product-item">' +
                    '<div class="product-image">' +
                    '<img src="' + imageUrl + '" alt="' + (product.name || '') + '">' +
                    '</div>' +
                    '<div class="product-info">' +
                    '<h3><a href="/product/detail?id=' + product.id + '">' + (product.name || '') + '</a></h3>' +
                    '<p class="description">' + (product.description || '') + '</p>' +
                    '<p class="price">¥' + (product.price || '0.00') + '</p>' +
                    '<p class="stock">库存：' + (product.stock || 0) + '</p>' +
                    '<button onclick="addToCart(' + product.id + ')">加入购物车</button>' +
                    '</div>' +
                    '</div>';
            });
            productList.innerHTML = html;
        }
        
        // 处理搜索表单提交
        function handleSearch(form) {
            var keyword = document.getElementById('searchKeyword').value.trim();
            if (keyword === '') {
                // 如果搜索框为空，显示所有商品
                loadAllProducts();
                return false;
            }
            return true;
        }
        
        // 显示所有商品
        function showAll() {
            document.getElementById('searchKeyword').value = '';
            loadAllProducts();
        }
    </script>
</body>
</html>

