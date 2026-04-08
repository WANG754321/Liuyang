package com.library.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class DBUtil {
    private static final String URL = System.getProperty(
            "db.url",
            "jdbc:mysql://localhost:3306/library_db?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai");
    private static final String USER = getConfig("db.user", "DB_USER");
    private static final String PASSWORD = getConfig("db.password", "DB_PASSWORD");

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL driver not found", e);
        }
    }

    private DBUtil() {
    }

    private static String getConfig(String propertyKey, String envKey) {
        String fromProperty = System.getProperty(propertyKey);
        if (fromProperty != null && !fromProperty.trim().isEmpty()) {
            return fromProperty.trim();
        }
        String fromEnv = System.getenv(envKey);
        if (fromEnv != null && !fromEnv.trim().isEmpty()) {
            return fromEnv.trim();
        }
        throw new IllegalStateException("Missing database config: set -D" + propertyKey + " or env " + envKey);
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
