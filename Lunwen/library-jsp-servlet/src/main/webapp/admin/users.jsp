<%@ page import="java.util.List" %>
<%@ page import="com.library.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>用户管理</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/WEB-INF/navbar.jspf"/>
<div class="container">
    <% if (request.getParameter("msg") != null) { %><div class="alert alert-success"><%= request.getParameter("msg") %></div><% } %>
    <% if (request.getParameter("error") != null) { %><div class="alert alert-danger"><%= request.getParameter("error") %></div><% } %>
    <div class="card mb-3">
        <div class="card-body">
            <h5>新增读者</h5>
            <form class="row g-2" method="post" action="${pageContext.request.contextPath}/admin/users">
                <input type="hidden" name="action" value="add">
                <div class="col-md-5"><input class="form-control" name="username" placeholder="用户名" required></div>
                <div class="col-md-5"><input class="form-control" type="password" name="password" placeholder="初始密码" minlength="6" required></div>
                <div class="col-md-2"><button class="btn btn-primary w-100" type="submit">添加</button></div>
            </form>
        </div>
    </div>

    <table class="table table-striped">
        <thead><tr><th>ID</th><th>用户名</th><th>操作</th></tr></thead>
        <tbody>
        <%
            List<User> readers = (List<User>) request.getAttribute("readers");
            if (readers != null) for (User u : readers) {
        %>
        <tr>
            <td><%= u.getId() %></td>
            <td><%= u.getUsername() %></td>
            <td>
                <form method="post" action="${pageContext.request.contextPath}/admin/users" onsubmit="return confirm('确认删除该读者？');" style="display:inline;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="<%= u.getId() %>">
                    <button class="btn btn-sm btn-danger" type="submit">删除</button>
                </form>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
</div>
</body>
</html>
