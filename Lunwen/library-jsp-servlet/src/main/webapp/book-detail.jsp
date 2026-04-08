<%@ page import="com.library.model.Book" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>图书详情</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/WEB-INF/navbar.jspf"/>
<div class="container">
    <%
        Book book = (Book) request.getAttribute("book");
    %>
    <div class="card">
        <div class="card-body">
            <h4 class="card-title"><%= book.getName() %></h4>
            <p class="card-text">ISBN：<%= book.getIsbn() %></p>
            <p class="card-text">作者：<%= book.getAuthor() %></p>
            <p class="card-text">出版社：<%= book.getPublisher() %></p>
            <p class="card-text">库存：<%= book.getStock() %></p>
            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/books">返回列表</a>
        </div>
    </div>
</div>
</body>
</html>
