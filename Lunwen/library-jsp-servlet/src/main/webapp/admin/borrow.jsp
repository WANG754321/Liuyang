<%@ page import="java.util.List" %>
<%@ page import="com.library.model.BorrowRecord" %>
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
    <title>借阅归还管理</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/WEB-INF/navbar.jspf"/>
<div class="container">
    <c:if test="${not empty param.msg}"><div class="alert alert-success"><c:out value="${param.msg}"/></div></c:if>
    <c:if test="${not empty param.error}"><div class="alert alert-danger"><c:out value="${param.error}"/></div></c:if>

    <div class="card mb-3">
        <div class="card-body">
            <h5>借阅登记</h5>
            <form class="row g-2" method="post" action="${pageContext.request.contextPath}/admin/borrow">
                <input type="hidden" name="action" value="borrow">
                <div class="col-md-3"><input class="form-control" name="userId" type="number" placeholder="读者ID" required></div>
                <div class="col-md-3"><input class="form-control" name="bookId" type="number" placeholder="图书ID" required></div>
                <div class="col-md-3"><input class="form-control" name="days" type="number" min="1" value="30" placeholder="借阅天数" required></div>
                <div class="col-md-3"><button class="btn btn-primary w-100" type="submit">办理借阅</button></div>
            </form>
        </div>
    </div>

    <div class="card">
        <div class="card-body">
            <h5>未归还记录（可办理归还）</h5>
            <table class="table table-striped">
                <thead><tr><th>记录ID</th><th>读者</th><th>图书</th><th>借阅时间</th><th>归还期限</th><th>操作</th></tr></thead>
                <tbody>
                <%
                    List<BorrowRecord> records = (List<BorrowRecord>) request.getAttribute("records");
                    if (records != null) for (BorrowRecord r : records) {
                %>
                <tr>
                    <td><%= r.getId() %></td>
                    <td><%= esc(r.getUsername()) %></td>
                    <td><%= esc(r.getBookName()) %></td>
                    <td><%= r.getBorrowTime() %></td>
                    <td><%= r.getReturnDeadline() %></td>
                    <td>
                        <form method="post" action="${pageContext.request.contextPath}/admin/borrow">
                            <input type="hidden" name="action" value="return">
                            <input type="hidden" name="recordId" value="<%= r.getId() %>">
                            <button class="btn btn-sm btn-success" type="submit">登记归还</button>
                        </form>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
