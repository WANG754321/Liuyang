package com.library.servlet;

import com.library.service.BorrowService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/overdue")
public class AdminOverdueServlet extends HttpServlet {
    private final BorrowService borrowService = new BorrowService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setAttribute("records", borrowService.listOverdue());
            req.getRequestDispatcher("/admin/overdue.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("逾期列表加载失败", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String idStr = req.getParameter("recordId");
        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/overdue?error=缺少记录ID");
            return;
        }
        try {
            boolean ok = borrowService.markReminded(Long.parseLong(idStr));
            resp.sendRedirect(req.getContextPath() + "/admin/overdue?msg=" + (ok ? "已标记人工提醒完成" : "标记失败"));
        } catch (SQLException e) {
            throw new ServletException("提醒标记失败", e);
        }
    }
}
