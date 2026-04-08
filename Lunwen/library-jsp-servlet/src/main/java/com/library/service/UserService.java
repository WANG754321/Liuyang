package com.library.service;

import com.library.dao.UserDao;
import com.library.model.User;
import com.library.util.PasswordUtil;

import java.sql.SQLException;
import java.util.List;

public class UserService {
    private final UserDao userDao = new UserDao();

    public User login(String username, String password) throws SQLException {
        User user = userDao.findByUsername(username);
        if (user == null) {
            return null;
        }
        return PasswordUtil.verifyPassword(password, user.getPassword()) ? user : null;
    }

    public boolean registerReader(String username, String password) throws SQLException {
        if (username == null || username.trim().isEmpty() || password == null || password.length() < 6) {
            return false;
        }
        if (userDao.findByUsername(username.trim()) != null) {
            return false;
        }
        return userDao.createReader(username.trim(), PasswordUtil.hashPassword(password)) > 0;
    }

    public boolean changePassword(Long userId, String oldPassword, String newPassword) throws SQLException {
        User user = userDao.findById(userId);
        if (user == null || newPassword == null || newPassword.length() < 6) {
            return false;
        }
        if (!PasswordUtil.verifyPassword(oldPassword, user.getPassword())) {
            return false;
        }
        return userDao.updatePassword(userId, PasswordUtil.hashPassword(newPassword)) > 0;
    }

    public boolean adminAddReader(String username, String password) throws SQLException {
        return registerReader(username, password);
    }

    public boolean adminDeleteReader(Long userId) throws SQLException {
        return userDao.deleteReader(userId) > 0;
    }

    public List<User> listReaders() throws SQLException {
        return userDao.listReaders();
    }
}
