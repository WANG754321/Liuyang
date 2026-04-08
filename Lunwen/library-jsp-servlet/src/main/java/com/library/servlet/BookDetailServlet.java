package com.library.servlet;

import com.library.model.Book;
import com.library.service.BookService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/book")
public class BookDetailServlet extends HttpServlet {
    private final BookService bookService = new BookService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/books?error=缺少图书ID");
            return;
        }
        try {
            Book book = bookService.findById(Long.parseLong(idStr));
            if (book == null) {
                resp.sendRedirect(req.getContextPath() + "/books?error=图书不存在");
                return;
            }
            req.setAttribute("book", book);
            req.getRequestDispatcher("/book-detail.jsp").forward(req, resp);
        } catch (SQLException | NumberFormatException e) {
            throw new ServletException("图书详情加载失败", e);
        }
    }
}
