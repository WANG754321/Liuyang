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

@WebServlet("/admin/books")
public class AdminBooksServlet extends HttpServlet {
    private final BookService bookService = new BookService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setAttribute("books", bookService.listAll());
            req.getRequestDispatcher("/admin/books.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("图书管理列表加载失败", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            boolean ok;
            if ("add".equals(action)) {
                ok = bookService.create(readBook(req, false));
            } else if ("update".equals(action)) {
                ok = bookService.update(readBook(req, true));
            } else if ("delete".equals(action)) {
                ok = bookService.delete(Long.parseLong(req.getParameter("id")));
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/books?error=未知操作");
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/admin/books?msg=" + (ok ? "操作成功" : "操作失败"));
        } catch (SQLException e) {
            throw new ServletException("图书管理操作失败", e);
        }
    }

    private Book readBook(HttpServletRequest req, boolean withId) {
        Book b = new Book();
        if (withId) {
            b.setId(Long.parseLong(req.getParameter("id")));
        }
        b.setIsbn(req.getParameter("isbn"));
        b.setName(req.getParameter("name"));
        b.setAuthor(req.getParameter("author"));
        b.setPublisher(req.getParameter("publisher"));
        b.setStock(Integer.parseInt(req.getParameter("stock")));
        return b;
    }
}
