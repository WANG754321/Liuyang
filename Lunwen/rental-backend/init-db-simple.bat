@echo off
chcp 65001 >nul

echo ========================================
echo    小区租房系统 - 数据库初始化脚本
echo ========================================
echo.

echo 正在创建数据库...
mysql -u root -p123456 -e "CREATE database if not exists rental_db default character set utf8mb4 collate utf8mb4_unicode_ci;" 2>&1

echo 正在创建用户表...
mysql -u root -p123456 -e "use rental_db;" 2>&1

echo 正在创建房屋表...
mysql -u root -p123456 -e "use rental_db;" 2>&1

echo 正在创建订单表...
mysql -u root -p123456 -e "use rental_db;" 2>&1

echo 正在插入测试数据...
mysql -u root -p123456 -e "use rental_db;" 2>&1

echo.
echo ========================================
echo    数据库初始化完成！
echo ========================================
echo.
pause
