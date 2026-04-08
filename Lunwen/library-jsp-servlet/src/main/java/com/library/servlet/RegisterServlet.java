package com.library.servlet;

import com.library.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        try {
            if (userService.registerReader(username, password)) {
                resp.sendRedirect(req.getContextPath() + "/login.jsp?msg=注册成功，请登录");
            } else {
                resp.sendRedirect(req.getContextPath() + "/register.jsp?error=注册失败，用户名已存在或参数不合法");
            }
        } catch (SQLException e) {
            throw new ServletException("注册失败", e);
        }
    }
}
