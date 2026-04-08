package com.library.servlet;

import com.library.service.BorrowService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/borrow")
public class AdminBorrowServlet extends HttpServlet {
    private final BorrowService borrowService = new BorrowService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setAttribute("records", borrowService.listUnreturned());
            req.getRequestDispatcher("/admin/borrow.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("借阅列表加载失败", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            boolean ok;
            if ("borrow".equals(action)) {
                Long userId = Long.parseLong(req.getParameter("userId"));
                Long bookId = Long.parseLong(req.getParameter("bookId"));
                int days = Integer.parseInt(req.getParameter("days"));
                ok = borrowService.borrow(userId, bookId, days);
            } else if ("return".equals(action)) {
                Long recordId = Long.parseLong(req.getParameter("recordId"));
                ok = borrowService.returnBook(recordId);
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/borrow?error=未知操作");
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/admin/borrow?msg=" + (ok ? "操作成功" : "操作失败，可能是库存不足或参数错误"));
        } catch (SQLException e) {
            throw new ServletException("借阅操作失败", e);
        }
    }
}
