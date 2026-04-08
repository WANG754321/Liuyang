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
    <title>个人中心</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/WEB-INF/navbar.jspf"/>
<div class="container">
    <c:if test="${not empty param.error}">
        <div class="alert alert-danger"><c:out value="${param.error}"/></div>
    </c:if>
    <div class="row">
        <div class="col-md-5">
            <div class="card mb-3">
                <div class="card-body">
                    <h5>修改密码</h5>
                    <form method="post" action="${pageContext.request.contextPath}/reader/change-password">
                        <div class="mb-2"><input class="form-control" type="password" name="oldPassword" placeholder="旧密码" required></div>
                        <div class="mb-2"><input class="form-control" type="password" name="newPassword" placeholder="新密码（至少6位）" minlength="6" required></div>
                        <button class="btn btn-primary" type="submit">提交</button>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-md-7">
            <div class="card">
                <div class="card-body">
                    <h5>我的借阅记录</h5>
                    <table class="table table-sm">
                        <thead><tr><th>ID</th><th>图书</th><th>借阅时间</th><th>归还期限</th><th>状态</th></tr></thead>
                        <tbody>
                        <%
                            List<BorrowRecord> records = (List<BorrowRecord>) request.getAttribute("records");
                            if (records != null) for (BorrowRecord r : records) {
                        %>
                        <tr>
                            <td><%= r.getId() %></td>
                            <td><%= esc(r.getBookName()) %></td>
                            <td><%= r.getBorrowTime() %></td>
                            <td><%= r.getReturnDeadline() %></td>
                            <td><%= r.getIsReturn() == 1 ? "已归还" : "未归还" %></td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
