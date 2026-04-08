package com.library.dao;

import com.library.model.BorrowRecord;
import com.library.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BorrowRecordDao {
    public int create(Connection conn, Long userId, Long bookId, LocalDateTime borrowTime, LocalDateTime deadline) throws SQLException {
        String sql = "INSERT INTO borrow_record(user_id, book_id, borrow_time, return_deadline, is_return) VALUES(?, ?, ?, ?, 0)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setLong(2, bookId);
            ps.setTimestamp(3, Timestamp.valueOf(borrowTime));
            ps.setTimestamp(4, Timestamp.valueOf(deadline));
            return ps.executeUpdate();
        }
    }

    public int markReturned(Connection conn, Long recordId) throws SQLException {
        String sql = "UPDATE borrow_record SET is_return = 1 WHERE id = ? AND is_return = 0";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, recordId);
            return ps.executeUpdate();
        }
    }

    public BorrowRecord findById(Connection conn, Long id) throws SQLException {
        String sql = "SELECT id, user_id, book_id, borrow_time, return_deadline, is_return FROM borrow_record WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRecord(rs);
                }
            }
        }
        return null;
    }

    public List<BorrowRecord> listByUser(Long userId) throws SQLException {
        String sql = "SELECT br.id, br.user_id, br.book_id, br.borrow_time, br.return_deadline, br.is_return, "
                + "u.username, b.name AS book_name "
                + "FROM borrow_record br "
                + "JOIN user u ON u.id = br.user_id "
                + "JOIN book b ON b.id = br.book_id "
                + "WHERE br.user_id = ? ORDER BY br.id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                List<BorrowRecord> list = new ArrayList<>();
                while (rs.next()) {
                    list.add(mapRecordWithJoin(rs));
                }
                return list;
            }
        }
    }

    public List<BorrowRecord> listUnreturned() throws SQLException {
        String sql = "SELECT br.id, br.user_id, br.book_id, br.borrow_time, br.return_deadline, br.is_return, "
                + "u.username, b.name AS book_name "
                + "FROM borrow_record br "
                + "JOIN user u ON u.id = br.user_id "
                + "JOIN book b ON b.id = br.book_id "
                + "WHERE br.is_return = 0 ORDER BY br.return_deadline ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<BorrowRecord> list = new ArrayList<>();
            while (rs.next()) {
                list.add(mapRecordWithJoin(rs));
            }
            return list;
        }
    }

    public List<BorrowRecord> listOverdue() throws SQLException {
        String sql = "SELECT br.id, br.user_id, br.book_id, br.borrow_time, br.return_deadline, br.is_return, "
                + "u.username, b.name AS book_name "
                + "FROM borrow_record br "
                + "JOIN user u ON u.id = br.user_id "
                + "JOIN book b ON b.id = br.book_id "
                + "WHERE br.is_return = 0 AND br.return_deadline < NOW() ORDER BY br.return_deadline ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<BorrowRecord> list = new ArrayList<>();
            while (rs.next()) {
                list.add(mapRecordWithJoin(rs));
            }
            return list;
        }
    }

    public int markReminded(Long id) throws SQLException {
        String sql = "UPDATE borrow_record SET reminded = 1, reminder_time = NOW() WHERE id = ? AND is_return = 0";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate();
        }
    }

    private BorrowRecord mapRecord(ResultSet rs) throws SQLException {
        BorrowRecord r = new BorrowRecord();
        r.setId(rs.getLong("id"));
        r.setUserId(rs.getLong("user_id"));
        r.setBookId(rs.getLong("book_id"));
        r.setBorrowTime(rs.getTimestamp("borrow_time").toLocalDateTime());
        r.setReturnDeadline(rs.getTimestamp("return_deadline").toLocalDateTime());
        r.setIsReturn(rs.getInt("is_return"));
        return r;
    }

    private BorrowRecord mapRecordWithJoin(ResultSet rs) throws SQLException {
        BorrowRecord r = mapRecord(rs);
        r.setUsername(rs.getString("username"));
        r.setBookName(rs.getString("book_name"));
        return r;
    }
}
