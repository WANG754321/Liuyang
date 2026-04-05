@echo off
chcp 65001 >nul
echo ========================================
echo    小区租房系统 - 启动脚本
echo ========================================
echo.

echo [1/2] 启动后端服务...
cd /d "%~dp0rental-backend"
start "后端服务 - Spring Boot" cmd /k "mvn spring-boot:run -s .mvn/settings.xml"

echo 等待后端启动...
timeout /t 10 /nobreak >nul

echo.
echo [2/2] 启动前端服务...
cd /d "%~dp0rental-frontend"
start "前端服务 - Vue" cmd /k "npm run dev"

echo.
echo ========================================
echo    服务启动完成！
echo ========================================
echo.
echo 前端地址: http://localhost:3000
echo 后端地址: http://localhost:8080
echo.
echo 按任意键退出...
pause >nul
