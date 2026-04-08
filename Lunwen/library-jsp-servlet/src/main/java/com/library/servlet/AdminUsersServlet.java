package com.library.servlet;

import com.library.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/users")
public class AdminUsersServlet extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setAttribute("readers", userService.listReaders());
            req.getRequestDispatcher("/admin/users.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("加载读者列表失败", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if ("add".equals(action)) {
                boolean ok = userService.adminAddReader(req.getParameter("username"), req.getParameter("password"));
                resp.sendRedirect(req.getContextPath() + "/admin/users?msg=" + (ok ? "新增成功" : "新增失败"));
            } else if ("delete".equals(action)) {
                boolean ok = userService.adminDeleteReader(Long.parseLong(req.getParameter("id")));
                resp.sendRedirect(req.getContextPath() + "/admin/users?msg=" + (ok ? "删除成功" : "删除失败"));
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/users?error=未知操作");
            }
        } catch (SQLException e) {
            throw new ServletException("读者管理失败", e);
        }
    }
}
