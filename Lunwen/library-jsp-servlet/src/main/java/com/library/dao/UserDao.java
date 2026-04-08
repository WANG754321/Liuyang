package com.library.dao;

import com.library.model.User;
import com.library.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserDao {
    public User findByUsername(String username) throws SQLException {
        String sql = "SELECT id, username, password, role FROM user WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        }
        return null;
    }

    public User findById(Long id) throws SQLException {
        String sql = "SELECT id, username, password, role FROM user WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        }
        return null;
    }

    public int createReader(String username, String hashedPassword) throws SQLException {
        String sql = "INSERT INTO user(username, password, role) VALUES(?, ?, 0)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, hashedPassword);
            return ps.executeUpdate();
        }
    }

    public int createReaderByAdmin(String username, String hashedPassword) throws SQLException {
        return createReader(username, hashedPassword);
    }

    public int deleteReader(Long id) throws SQLException {
        String sql = "DELETE FROM user WHERE id = ? AND role = 0";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate();
        }
    }

    public int updatePassword(Long id, String hashedPassword) throws SQLException {
        String sql = "UPDATE user SET password = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setLong(2, id);
            return ps.executeUpdate();
        }
    }

    public List<User> listReaders() throws SQLException {
        String sql = "SELECT id, username, password, role FROM user WHERE role = 0 ORDER BY id DESC";
        List<User> users = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                users.add(mapUser(rs));
            }
        }
        return users;
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getLong("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setRole(rs.getInt("role"));
        return user;
    }
}
