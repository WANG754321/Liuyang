CREATE DATABASE IF NOT EXISTS library_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE library_db;

DROP TABLE IF EXISTS borrow_record;
DROP TABLE IF EXISTS book;
DROP TABLE IF EXISTS user;

CREATE TABLE user (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(64) NOT NULL,
    role TINYINT NOT NULL DEFAULT 0 COMMENT '0-reader,1-admin'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE book (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    isbn VARCHAR(30) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    author VARCHAR(100) NOT NULL,
    publisher VARCHAR(100) NOT NULL,
    stock INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE borrow_record (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    book_id BIGINT NOT NULL,
    borrow_time DATETIME NOT NULL,
    return_deadline DATETIME NOT NULL,
    is_return TINYINT NOT NULL DEFAULT 0 COMMENT '0-unreturned,1-returned',
    CONSTRAINT fk_borrow_user FOREIGN KEY (user_id) REFERENCES user(id),
    CONSTRAINT fk_borrow_book FOREIGN KEY (book_id) REFERENCES book(id),
    INDEX idx_borrow_user_id(user_id),
    INDEX idx_borrow_book_id(book_id),
    INDEX idx_borrow_deadline(return_deadline, is_return)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- default admin/admin123 (sha256)
INSERT INTO user(username, password, role) VALUES
('admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 1);

INSERT INTO book(isbn, name, author, publisher, stock) VALUES
('9787302511850', 'Java Web开发实战', '王某', '清华大学出版社', 10),
('9787111641247', '深入理解Servlet与JSP', '李某', '机械工业出版社', 6);
