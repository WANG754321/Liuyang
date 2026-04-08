package com.library.dao;

import com.library.model.Book;
import com.library.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BookDao {
    public List<Book> search(String keyword) throws SQLException {
        String sql = "SELECT id, isbn, name, author, publisher, stock FROM book "
                + "WHERE name LIKE ? OR author LIKE ? ORDER BY id DESC";
        List<Book> books = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String like = "%" + keyword + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapBook(rs));
                }
            }
        }
        return books;
    }

    public List<Book> listAll() throws SQLException {
        String sql = "SELECT id, isbn, name, author, publisher, stock FROM book ORDER BY id DESC";
        List<Book> books = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                books.add(mapBook(rs));
            }
        }
        return books;
    }

    public Book findById(Long id) throws SQLException {
        String sql = "SELECT id, isbn, name, author, publisher, stock FROM book WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBook(rs);
                }
            }
        }
        return null;
    }

    public int create(Book book) throws SQLException {
        String sql = "INSERT INTO book(isbn, name, author, publisher, stock) VALUES(?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, book.getIsbn());
            ps.setString(2, book.getName());
            ps.setString(3, book.getAuthor());
            ps.setString(4, book.getPublisher());
            ps.setInt(5, book.getStock());
            return ps.executeUpdate();
        }
    }

    public int update(Book book) throws SQLException {
        String sql = "UPDATE book SET isbn=?, name=?, author=?, publisher=?, stock=? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, book.getIsbn());
            ps.setString(2, book.getName());
            ps.setString(3, book.getAuthor());
            ps.setString(4, book.getPublisher());
            ps.setInt(5, book.getStock());
            ps.setLong(6, book.getId());
            return ps.executeUpdate();
        }
    }

    public int delete(Long id) throws SQLException {
        String sql = "DELETE FROM book WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate();
        }
    }

    public Book findById(Connection conn, Long id) throws SQLException {
        String sql = "SELECT id, isbn, name, author, publisher, stock FROM book WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBook(rs);
                }
            }
        }
        return null;
    }

    public int changeStock(Connection conn, Long id, int delta) throws SQLException {
        String sql = "UPDATE book SET stock = stock + ? WHERE id = ? AND stock + ? >= 0";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, delta);
            ps.setLong(2, id);
            ps.setInt(3, delta);
            return ps.executeUpdate();
        }
    }

    private Book mapBook(ResultSet rs) throws SQLException {
        Book b = new Book();
        b.setId(rs.getLong("id"));
        b.setIsbn(rs.getString("isbn"));
        b.setName(rs.getString("name"));
        b.setAuthor(rs.getString("author"));
        b.setPublisher(rs.getString("publisher"));
        b.setStock(rs.getInt("stock"));
        return b;
    }
}
