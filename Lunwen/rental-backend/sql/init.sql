CREATE DATABASE IF NOT exists rental_db DEFAULT CHARACTER set utf8mb4 COLLate utf8mb4_unicode_ci;

USE rental_db;

CREATE TABLE IF not exists user (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(100) NOT NULL COMMENT '密码',
    real_name VARCHAR(100) COMMENT '真实姓名',
    phone VARCHAR(20) COMMENT '手机号',
    email VARCHAR(100) COMMENT '邮箱',
    role VARCHAR(20) DEFAULT 'tenant' COMMENT '角色: admin-管理员, landlord-房东, tenant-租客',
    status TINYINT DEFAULT 1 COMMENT '状态: 0-禁用, 1-启用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

create table if not exists house (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '房屋ID',
    title VARCHAR(100) NOT NULL COMMENT '房屋标题',
    address VARCHAR(200) not null COMMENT '详细地址',
    area DECIMAL(10,2) COMMENT '面积(平方米)',
    price DECIMAL(10,2) NOT NULL COMMENT '月租金',
    room_count INT COMMENT '房间数',
    hall_count INT COMMENT '客厅数',
    floor VARCHAR(20) COMMENT '楼层',
    orientation VARCHAR(20) COMMENT '朝向',
    decoration VARCHAR(50) COMMENT '装修情况',
    facilities VARCHAR(500) COMMENT '配套设施',
    description TEXT COMMENT '房屋描述',
    image_url VARCHAR(500) COMMENT '房屋图片',
    landlord_id BIGINT NOT NULL COMMENT '房东ID',
    status TINYINT DEFAULT 1 COMMENT '状态: 0-下架, 1-上架, 2-已租',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (landlord_id) REFERENCES user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='房屋表';

create table if not exists rental_order (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '订单ID',
    order_no VARCHAR(50) NOT NULL UNIQUE COMMENT '订单编号',
    house_id BIGINT NOT NULL COMMENT '房屋ID',
    tenant_id BIGINT NOT NULL COMMENT '租客ID',
    landlord_id BIGINT NOT NULL COMMENT '房东ID',
    start_date DATE NOT NULL COMMENT '起租日期',
    end_date DATE NOT NULL COMMENT '结束日期',
    monthly_rent DECIMAL(10,2) NOT NULL COMMENT '月租金',
    deposit DECIMAL(10,2) COMMENT '押金',
    total_amount DECIMAL(10,2) COMMENT '总金额',
    status TINYINT DEFAULT 0 COMMENT '状态: 0-待确认, 1-已确认, 2-进行中, 3-已完成, 4-已取消',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP on UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (house_id) REFERENCES house(id),
    FOREIGN KEY (tenant_id) REFERENCES user(id),
    FOREIGN KEY (landlord_id) REFERENCES user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='租赁订单表';

INSERT into user (username, password, real_name, phone, email, role) values
('admin', 'admin123', '系统管理员', '13800138000', 'admin@rental.com', 'admin'),
('landlord1', '123456', '张房东', '13800138001', 'landlord1@rental.com', 'landlord'),
('tenant1', '123456', '李租客', '13800138002', 'tenant1@rental.com', 'tenant');

insert into house (title, address, area, price, room_count, hall_count, floor, orientation, decoration, facilities, description, landlord_id, status) values
('阳光花园精装两居室', '北京市朝阳区阳光花园小区1号楼101室', 85.00, 5000.00, 2, 1, '10层', '南北通透', '精装修', '空调,冰箱,洗衣机,热水器,宽带', '交通便利，周边配套设施齐全，拎包入住', 2, 1),
('温馨一居室出租', '北京市海淀区中关村大街88号', 45.00, 3500.00, 1, 1, '5层', '朝南', '简装修', '空调,热水器', '靠近地铁站，适合单身人士', 2, 1);
