<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户注册</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="header">
        <div class="container">
            <h1>在线购物网站</h1>
        </div>
    </div>

    <div class="container">
        <div class="register-form">
            <h2>用户注册</h2>
            <form id="registerForm">
                <div class="form-group">
                    <label>用户名：</label>
                    <input type="text" name="username" required>
                </div>
                <div class="form-group">
                    <label>密码：</label>
                    <input type="password" name="password" required>
                </div>
                <div class="form-group">
                    <label>邮箱：</label>
                    <input type="email" name="email" required>
                </div>
                <div class="form-group">
                    <label>电话：</label>
                    <input type="text" name="phone">
                </div>
                <div class="form-group">
                    <label>地址：</label>
                    <input type="text" name="address">
                </div>
                <div class="form-group">
                    <button type="submit">注册</button>
                    <a href="${pageContext.request.contextPath}/user/login.jsp">已有账号？立即登录</a>
                </div>
            </form>
            <div id="message"></div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/common.js"></script>
    <script>
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const form = this;
            const formData = new FormData(form);
            
            // 使用URLSearchParams确保参数正确传递
            const params = new URLSearchParams();
            for (const [key, value] of formData.entries()) {
                params.append(key, value);
            }
            
            fetch('${pageContext.request.contextPath}/user/register', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params.toString()
            })
            .then(response => response.json())
            .then(data => {
                const messageDiv = document.getElementById('message');
                if (data.success) {
                    messageDiv.innerHTML = '<p class="success">' + data.message + '</p>';
                    setTimeout(() => {
                        window.location.href = '${pageContext.request.contextPath}/user/login.jsp';
                    }, 1000);
                } else {
                    messageDiv.innerHTML = '<p class="error">' + data.message + '</p>';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                document.getElementById('message').innerHTML = '<p class="error">注册失败，请重试</p>';
            });
        });
    </script>
</body>
</html>

