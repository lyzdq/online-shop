<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑商品</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="header">
        <div class="container">
            <h1>管理后台</h1>
        </div>
    </div>

    <div class="container">
        <h2>编辑商品</h2>
        <form id="editProductForm" enctype="multipart/form-data">
            <input type="hidden" name="id" value="${product.id}">
            <div class="form-group">
                <label>商品名称：</label>
                <input type="text" name="name" value="${product.name}" required>
            </div>
            <div class="form-group">
                <label>商品描述：</label>
                <textarea name="description" rows="5">${product.description}</textarea>
            </div>
            <div class="form-group">
                <label>价格：</label>
                <input type="number" name="price" step="0.01" min="0" value="${product.price}" required>
            </div>
            <div class="form-group">
                <label>库存：</label>
                <input type="number" name="stock" min="0" value="${product.stock}" required>
            </div>
            <div class="form-group">
                <label>分类：</label>
                <input type="text" name="category" value="${product.category}">
            </div>
            <div class="form-group">
                <label>当前图片：</label>
                <c:if test="${product.image != null && product.image != ''}">
                    <img src="${product.image}" alt="当前图片" style="max-width: 200px; max-height: 200px; display: block; margin-bottom: 10px;">
                </c:if>
                <label>上传新图片（可选）：</label>
                <input type="file" name="imageFile" accept="image/*">
                <small>支持jpg、png、gif格式，最大10MB。不选择则保持原图片</small>
            </div>
            <div class="form-group">
                <label>状态：</label>
                <select name="status">
                    <option value="1" ${product.status == 1 ? 'selected' : ''}>上架</option>
                    <option value="0" ${product.status == 0 ? 'selected' : ''}>下架</option>
                </select>
            </div>
            <div class="form-group">
                <button type="submit">更新</button>
                <a href="/admin/product/list">返回</a>
            </div>
        </form>
        <div id="message"></div>
    </div>

    <script>
        document.getElementById('editProductForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            fetch('/admin/product/update', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                const messageDiv = document.getElementById('message');
                if (data.success) {
                    messageDiv.innerHTML = '<p class="success">' + data.message + '</p>';
                    setTimeout(() => {
                        window.location.href = '/admin/product/list';
                    }, 1000);
                } else {
                    messageDiv.innerHTML = '<p class="error">' + data.message + '</p>';
                }
            })
            .catch(error => {
                const messageDiv = document.getElementById('message');
                messageDiv.innerHTML = '<p class="error">提交失败：' + error.message + '</p>';
            });
        });
    </script>
</body>
</html>

