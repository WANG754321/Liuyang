<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>注册 - 图书借阅系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5" style="max-width: 480px;">
    <div class="card">
        <div class="card-body">
            <h3 class="mb-3 text-center">读者注册</h3>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger"><c:out value="${param.error}"/></div>
            </c:if>
            <form method="post" action="${pageContext.request.contextPath}/register">
                <div class="mb-3">
                    <label class="form-label">用户名</label>
                    <input class="form-control" type="text" name="username" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">密码（至少6位）</label>
                    <input class="form-control" type="password" name="password" required minlength="6">
                </div>
                <button class="btn btn-success w-100" type="submit">注册</button>
            </form>
            <div class="mt-3 text-center">
                <a href="${pageContext.request.contextPath}/login.jsp">已有账号？去登录</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
