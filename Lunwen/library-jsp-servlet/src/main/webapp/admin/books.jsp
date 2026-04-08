<%@ page import="java.util.List" %>
<%@ page import="com.library.model.Book" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%! private String esc(Object v){
    if (v == null) return "";
    String s = String.valueOf(v);
    return s.replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
} %>
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
    <c:if test="${not empty param.msg}"><div class="alert alert-success"><c:out value="${param.msg}"/></div></c:if>
    <c:if test="${not empty param.error}"><div class="alert alert-danger"><c:out value="${param.error}"/></div></c:if>

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
                <td><input class="form-control form-control-sm" name="isbn" value="<%= esc(b.getIsbn()) %>" required></td>
                <td><input class="form-control form-control-sm" name="name" value="<%= esc(b.getName()) %>" required></td>
                <td><input class="form-control form-control-sm" name="author" value="<%= esc(b.getAuthor()) %>" required></td>
                <td><input class="form-control form-control-sm" name="publisher" value="<%= esc(b.getPublisher()) %>" required></td>
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
