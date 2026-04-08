<%@ page import="java.util.List" %>
<%@ page import="com.library.model.BorrowRecord" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>逾期提醒</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/WEB-INF/navbar.jspf"/>
<div class="container">
    <% if (request.getParameter("msg") != null) { %><div class="alert alert-success"><%= request.getParameter("msg") %></div><% } %>
    <div class="card">
        <div class="card-body">
            <h5>逾期未归还列表（管理员人工提醒）</h5>
            <table class="table table-striped">
                <thead><tr><th>记录ID</th><th>读者</th><th>图书</th><th>归还期限</th><th>操作</th></tr></thead>
                <tbody>
                <%
                    List<BorrowRecord> records = (List<BorrowRecord>) request.getAttribute("records");
                    if (records != null) for (BorrowRecord r : records) {
                %>
                <tr>
                    <td><%= r.getId() %></td>
                    <td><%= r.getUsername() %></td>
                    <td><%= r.getBookName() %></td>
                    <td class="text-danger"><%= r.getReturnDeadline() %></td>
                    <td>
                        <form method="post" action="${pageContext.request.contextPath}/admin/overdue">
                            <button class="btn btn-sm btn-warning" type="submit">标记已提醒</button>
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
