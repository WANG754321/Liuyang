package com.library.service;

import com.library.dao.BookDao;
import com.library.model.Book;

import java.sql.SQLException;
import java.util.List;

public class BookService {
    private final BookDao bookDao = new BookDao();

    public List<Book> search(String keyword) throws SQLException {
        if (keyword == null || keyword.trim().isEmpty()) {
            return bookDao.listAll();
        }
        return bookDao.search(keyword.trim());
    }

    public List<Book> listAll() throws SQLException {
        return bookDao.listAll();
    }

    public Book findById(Long id) throws SQLException {
        return bookDao.findById(id);
    }

    public boolean create(Book book) throws SQLException {
        if (!validBook(book)) {
            return false;
        }
        return bookDao.create(book) > 0;
    }

    public boolean update(Book book) throws SQLException {
        if (book.getId() == null || !validBook(book)) {
            return false;
        }
        return bookDao.update(book) > 0;
    }

    public boolean delete(Long id) throws SQLException {
        return bookDao.delete(id) > 0;
    }

    private boolean validBook(Book book) {
        return book != null
                && notBlank(book.getIsbn())
                && notBlank(book.getName())
                && notBlank(book.getAuthor())
                && notBlank(book.getPublisher())
                && book.getStock() != null
                && book.getStock() >= 0;
    }

    private boolean notBlank(String s) {
        return s != null && !s.trim().isEmpty();
    }
}
