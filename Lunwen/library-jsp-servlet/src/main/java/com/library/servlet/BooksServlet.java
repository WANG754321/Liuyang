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
import java.util.List;

@WebServlet("/books")
public class BooksServlet extends HttpServlet {
    private final BookService bookService = new BookService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String q = req.getParameter("q");
        try {
            List<Book> books = bookService.search(q);
            req.setAttribute("books", books);
            req.getRequestDispatcher("/books.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("图书列表加载失败", e);
        }
    }
}
