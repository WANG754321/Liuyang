package com.library.service;

import com.library.dao.BookDao;
import com.library.dao.BorrowRecordDao;
import com.library.dao.UserDao;
import com.library.model.Book;
import com.library.model.BorrowRecord;
import com.library.model.User;
import com.library.util.DBUtil;

import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

public class BorrowService {
    private final UserDao userDao = new UserDao();
    private final BookDao bookDao = new BookDao();
    private final BorrowRecordDao borrowRecordDao = new BorrowRecordDao();

    public boolean borrow(Long userId, Long bookId, int days) throws SQLException {
        if (userId == null || bookId == null || days <= 0) {
            return false;
        }
        User user = userDao.findById(userId);
        if (user == null || user.getRole() != 0) {
            return false;
        }
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            try {
                Book book = bookDao.findById(conn, bookId);
                if (book == null || book.getStock() <= 0) {
                    conn.rollback();
                    return false;
                }
                if (bookDao.changeStock(conn, bookId, -1) <= 0) {
                    conn.rollback();
                    return false;
                }
                LocalDateTime now = LocalDateTime.now();
                LocalDateTime deadline = now.plusDays(days);
                if (borrowRecordDao.create(conn, userId, bookId, now, deadline) <= 0) {
                    conn.rollback();
                    return false;
                }
                conn.commit();
                return true;
            } catch (Exception ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    public boolean returnBook(Long recordId) throws SQLException {
        if (recordId == null) {
            return false;
        }
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            try {
                BorrowRecord record = borrowRecordDao.findById(conn, recordId);
                if (record == null || record.getIsReturn() == 1) {
                    conn.rollback();
                    return false;
                }
                if (borrowRecordDao.markReturned(conn, recordId) <= 0) {
                    conn.rollback();
                    return false;
                }
                if (bookDao.changeStock(conn, record.getBookId(), 1) <= 0) {
                    conn.rollback();
                    return false;
                }
                conn.commit();
                return true;
            } catch (Exception ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    public List<BorrowRecord> listByUser(Long userId) throws SQLException {
        return borrowRecordDao.listByUser(userId);
    }

    public List<BorrowRecord> listUnreturned() throws SQLException {
        return borrowRecordDao.listUnreturned();
    }

    public List<BorrowRecord> listOverdue() throws SQLException {
        return borrowRecordDao.listOverdue();
    }

    public boolean markReminded(Long recordId) throws SQLException {
        if (recordId == null) {
            return false;
        }
        return borrowRecordDao.markReminded(recordId) > 0;
    }
}
