<%@ page import="java.util.List" %>
<%@ page import="com.library.model.Book" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>图书管理</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/WEB-INF/navbar.jspf"/>
<div class="container">
    <% if (request.getParameter("msg") != null) { %><div class="alert alert-success"><%= request.getParameter("msg") %></div><% } %>
    <% if (request.getParameter("error") != null) { %><div class="alert alert-danger"><%= request.getParameter("error") %></div><% } %>

    <div class="card mb-3">
        <div class="card-body">
            <h5>新增图书</h5>
            <form class="row g-2" method="post" action="${pageContext.request.contextPath}/admin/books">
                <input type="hidden" name="action" value="add">
                <div class="col-md-2"><input class="form-control" name="isbn" placeholder="ISBN" required></div>
                <div class="col-md-2"><input class="form-control" name="name" placeholder="书名" required></div>
                <div class="col-md-2"><input class="form-control" name="author" placeholder="作者" required></div>
                <div class="col-md-2"><input class="form-control" name="publisher" placeholder="出版社" required></div>
                <div class="col-md-2"><input class="form-control" type="number" name="stock" min="0" placeholder="库存" required></div>
                <div class="col-md-2"><button class="btn btn-primary w-100" type="submit">添加</button></div>
            </form>
        </div>
    </div>

    <table class="table table-striped">
        <thead><tr><th>ID</th><th>ISBN</th><th>书名</th><th>作者</th><th>出版社</th><th>库存</th><th>操作</th></tr></thead>
        <tbody>
        <%
            List<Book> books = (List<Book>) request.getAttribute("books");
            if (books != null) for (Book b : books) {
        %>
        <tr>
            <form method="post" action="${pageContext.request.contextPath}/admin/books">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= b.getId() %>">
                <td><%= b.getId() %></td>
                <td><input class="form-control form-control-sm" name="isbn" value="<%= b.getIsbn() %>" required></td>
                <td><input class="form-control form-control-sm" name="name" value="<%= b.getName() %>" required></td>
                <td><input class="form-control form-control-sm" name="author" value="<%= b.getAuthor() %>" required></td>
                <td><input class="form-control form-control-sm" name="publisher" value="<%= b.getPublisher() %>" required></td>
                <td><input class="form-control form-control-sm" type="number" name="stock" min="0" value="<%= b.getStock() %>" required></td>
                <td class="d-flex gap-2">
                    <button class="btn btn-sm btn-warning" type="submit">保存</button>
            </form>
            <form method="post" action="${pageContext.request.contextPath}/admin/books" onsubmit="return confirm('确认删除该图书？');">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" value="<%= b.getId() %>">
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
