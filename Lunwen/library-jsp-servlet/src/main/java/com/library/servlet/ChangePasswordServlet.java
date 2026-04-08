package com.library.servlet;

import com.library.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;

@WebServlet("/reader/change-password")
public class ChangePasswordServlet extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long userId = (Long) req.getSession().getAttribute("userId");
        String oldPwd = req.getParameter("oldPassword");
        String newPwd = req.getParameter("newPassword");
        try {
            boolean ok = userService.changePassword(userId, oldPwd, newPwd);
            String msg = ok ? "密码修改成功，请重新登录" : "密码修改失败，旧密码错误或新密码不合法";
            if (ok) {
                req.getSession().invalidate();
                resp.sendRedirect(req.getContextPath() + "/login.jsp?msg="
                        + URLEncoder.encode(msg, StandardCharsets.UTF_8.name()));
            } else {
                resp.sendRedirect(req.getContextPath() + "/reader/center?error="
                        + URLEncoder.encode(msg, StandardCharsets.UTF_8.name()));
            }
        } catch (SQLException e) {
            throw new ServletException("修改密码失败", e);
        }
    }
}
