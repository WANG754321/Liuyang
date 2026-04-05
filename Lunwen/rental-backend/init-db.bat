@echo off
echo ========================================
echo    MySQL数据库初始化脚本
echo ========================================
echo.
echo 请确保MySQL服务已启动！
echo.
echo 正在尝试连接MySQL...
mysql -u root -p123456 -e "SELECT 1;" 2>nul
if %errorlevel% equ 0 (
    echo.
    echo [成功] MySQL连接成功！
    echo.
    echo 正在创建数据库...
    mysql -u root -p123456 -e "CREATE DATABASE IF NOT exists rental_db DEFAULT CHARACTER set utf8mb4 COLLate utf8mb4_unicode_ci;" 2>nul
    
    echo [成功] 数据库 rental_db 创建成功！
    echo.
    echo 正在创建用户表...
    mysql -u root -p123456 rental_db -e "
    CREATE table if not exists user (
        id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
        username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
        password VARCHAR(100) NOT NULL COMMENT '密码',
        real_name VARCHAR(50) COMMENT '真实姓名',
        phone VARCHAR(20) COMMENT '手机号',
        email VARCHAR(100) COMMENT '邮箱',
        role VARCHAR(20) DEFAULT 'tenant' COMMENT '角色: admin-管理员, landlord-房东, tenant-租客',
        status TINYINT DEFAULT 1 COMMENT '状态: 0-禁用, 1-启用',
        create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
        update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';
    if %errorlevel% neq 0 (
        echo [成功] 用户表创建成功！        
    ) else (
        echo [失败] 用户表创建失败
    )
)
if %errorlevel% equ 0 (
    echo.
    echo 正在创建房屋表...
    mysql -u root -p123456 rental_db -e "
    create table if not exists house (
        id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '房屋ID',
        title VARCHAR(100) NOT NULL COMMENT '房屋标题',
        address VARCHAR(200) NOT null COMMENT '详细地址',
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
    if %errorlevel% neq 0 (
        echo [成功] 房屋表创建成功!        
    ) else (
        echo [失败] 房屋表创建失败
    )
)
if %errorlevel% equ 0 (
    echo.
    echo 正在创建订单表...
    mysql -u root -p123456 rental_db -e "
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
        update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
        FOREIGN KEY (house_id) REFERENCES house(id),
        FOREIGN KEY (tenant_id) REFERENCES user(id),
        FOREIGN KEY (landlord_id) REFERENCES user(id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='租赁订单表';
    if %errorlevel% neq 0 (
        echo [成功] 订单表创建成功!        
    ) else (
        echo [失败] 订单表创建失败
    }
)
if %errorlevel% equ 0 (
    echo.
    echo 正在插入测试数据...
    mysql -u root -p123456 rental_db -e "
    INSERT INTO user (username, password, real_name, phone, email, role) VALUES
        ('admin', 'admin123', '系统管理员', '13800138000', 'admin@rental.com', 'admin'),
        ('landlord1', '123456', '张房东', '13800138001', 'landlord1@rental.com', 'landlord'),
        ('tenant1', '123456', '李租客', '13800138002', 'tenant1@rental.com', 'tenant');
    " 2>nul
    
    if %errorlevel% neq 0 (
        echo [成功] 测试数据插入成功!        
    ) else (
        echo [失败] 测试数据插入失败
    )
)
if %errorlevel% equ 0 (
    echo.
    echo 正在插入房屋数据...
    mysql -u root -p123456 rental_db -e "
    INSERT INTO house (title, address, area, price, room_count, hall_count, floor, orientation, decoration, facilities, description, landlord_id, status) VALUES
        ('阳光花园精装两居室', '北京市朝阳区阳光花园小区1号楼101室', 85.00, 5000.00, 2, 1, '10层', '南北通透', '精装修', '空调,冰箱,洗衣机,热水器,宽带', '交通便利，周边配套设施齐全，拎包入住', 2, 1),
        ('温馨一居室出租', '北京市海淀区中关村大街88号', 45.00, 3500.00, 1, 1, '5层', '朝南', '简装修', '空调,热水器', '靠近地铁站，适合单身人士', 2, 1);
    " 2>nul
    
    if %errorlevel% neq 0 (
        echo [成功] 房屋数据插入成功!        
    ) else (
        echo [失败] 房屋数据插入失败
    }
)

echo.
echo ========================================
echo    数据库初始化完成！
echo ========================================
pause
