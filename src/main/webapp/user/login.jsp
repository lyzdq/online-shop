<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户登录</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="header">
        <div class="container">
            <h1>在线购物网站</h1>
        </div>
    </div>

    <div class="container">
        <div class="login-form">
            <h2>用户登录</h2>
            <form id="loginForm">
                <div class="form-group">
                    <label>用户名：</label>
                    <input type="text" name="username" required>
                </div>
                <div class="form-group">
                    <label>密码：</label>
                    <input type="password" name="password" required>
                </div>
                <div class="form-group">
                    <button type="submit">登录</button>
                    <a href="${pageContext.request.contextPath}/user/register.jsp">还没有账号？立即注册</a>
                </div>
            </form>
            <div id="message"></div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/common.js"></script>
    <script>
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const form = this;
            const formData = new FormData(form);
            
            // 使用URLSearchParams确保参数正确传递
            const params = new URLSearchParams();
            for (const [key, value] of formData.entries()) {
                params.append(key, value);
            }
            
            fetch('${pageContext.request.contextPath}/user/login', {
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
                        window.location.href = '${pageContext.request.contextPath}/index.jsp';
                    }, 1000);
                } else {
                    messageDiv.innerHTML = '<p class="error">' + data.message + '</p>';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                document.getElementById('message').innerHTML = '<p class="error">登录失败，请重试</p>';
            });
        });
    </script>
</body>
</html>

