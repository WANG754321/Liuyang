package com.library.servlet;

import com.library.service.BorrowService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/reader/center")
public class ReaderCenterServlet extends HttpServlet {
    private final BorrowService borrowService = new BorrowService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long userId = (Long) req.getSession().getAttribute("userId");
        try {
            req.setAttribute("records", borrowService.listByUser(userId));
            req.getRequestDispatcher("/reader/center.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("个人中心加载失败", e);
        }
    }
}
