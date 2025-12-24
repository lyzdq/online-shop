<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>购物车</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="header">
        <div class="container">
            <h1>在线购物网站</h1>
            <div class="user-info">
                欢迎，${sessionScope.user.username} | 
                <a href="/index.jsp">首页</a> | 
                <a href="/order/list">我的订单</a> | 
                <a href="/user/logout">退出</a>
            </div>
        </div>
    </div>

    <div class="container">
        <h2>购物车</h2>
        <c:if test="${empty cartItems}">
            <p>购物车为空</p>
            <a href="/index.jsp">去购物</a>
        </c:if>
        <c:if test="${not empty cartItems}">
            <table class="cart-table">
                <thead>
                    <tr>
                        <th>商品</th>
                        <th>单价</th>
                        <th>数量</th>
                        <th>小计</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${cartItems}">
                        <tr>
                            <td>
                                <img src="${item.product.image != null ? item.product.image : '/images/default.jpg'}" 
                                     alt="${item.product.name}" class="cart-product-image">
                                ${item.product.name}
                            </td>
                            <td>¥${item.product.price}</td>
                            <td>
                                <input type="number" value="${item.quantity}" min="1" 
                                       max="${item.product.stock}" 
                                       onchange="updateQuantity(${item.id}, this.value)">
                            </td>
                            <td>¥${item.product.price * item.quantity}</td>
                            <td>
                                <button onclick="removeFromCart(${item.id})">删除</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div class="cart-actions">
                <button onclick="checkout()">结算</button>
            </div>
        </c:if>
    </div>

    <div id="checkoutModal" class="modal" style="display:none;">
        <div class="modal-content">
            <h3>确认订单</h3>
            <form id="checkoutForm">
                <div class="form-group">
                    <label>收货地址：</label>
                    <input type="text" name="address" required>
                </div>
                <div class="form-group">
                    <label>联系电话：</label>
                    <input type="text" name="phone" required>
                </div>
                <div class="form-group">
                    <button type="submit">确认下单</button>
                    <button type="button" onclick="closeModal()">取消</button>
                </div>
            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/common.js"></script>
    <script>
        function updateQuantity(cartId, quantity) {
            fetch('/cart/update', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'cartId=' + cartId + '&quantity=' + quantity
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert(data.message);
                }
            });
        }

        function removeFromCart(cartId) {
            if (confirm('确定要删除吗？')) {
                fetch('/cart/remove', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'cartId=' + cartId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    } else {
                        alert(data.message);
                    }
                });
            }
        }

        function checkout() {
            document.getElementById('checkoutModal').style.display = 'block';
        }

        function closeModal() {
            document.getElementById('checkoutModal').style.display = 'none';
        }

        document.getElementById('checkoutForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            fetch('/order/create', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('订单创建成功！订单号：' + data.orderNo);
                    window.location.href = '/order/list';
                } else {
                    alert(data.message);
                }
            });
        });
    </script>
</body>
</html>

