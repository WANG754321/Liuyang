<%@ page import="java.util.List" %>
<%@ page import="com.library.model.Book" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>图书列表</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/WEB-INF/navbar.jspf"/>
<div class="container">
    <c:if test="${not empty param.error}">
        <div class="alert alert-danger"><c:out value="${param.error}"/></div>
    </c:if>
    <c:if test="${not empty param.msg}">
        <div class="alert alert-success"><c:out value="${param.msg}"/></div>
    </c:if>
    <form class="row g-2 mb-3" method="get" action="${pageContext.request.contextPath}/books">
        <div class="col-md-8">
            <input class="form-control" name="q" placeholder="按书名或作者搜索" value="<c:out value='${param.q}'/>">
        </div>
        <div class="col-md-4">
            <button class="btn btn-primary" type="submit">搜索</button>
        </div>
    </form>
    <table class="table table-striped table-hover">
        <thead>
        <tr>
            <th>ID</th><th>ISBN</th><th>书名</th><th>作者</th><th>出版社</th><th>库存</th><th>操作</th>
        </tr>
        </thead>
        <tbody>
        <%
            List<Book> books = (List<Book>) request.getAttribute("books");
            if (books != null) {
                for (Book b : books) {
        %>
        <tr>
            <td><%= b.getId() %></td>
            <td><%= b.getIsbn() %></td>
            <td><%= b.getName() %></td>
            <td><%= b.getAuthor() %></td>
            <td><%= b.getPublisher() %></td>
            <td><%= b.getStock() %></td>
            <td><a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/book?id=<%= b.getId() %>">详情</a></td>
        </tr>
        <%      }
            }
        %>
        </tbody>
    </table>
</div>
</body>
</html>
