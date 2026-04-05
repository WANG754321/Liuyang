@echo off
chcp 65001 >nul
echo ========================================
echo    小区租房系统 - 完整启动指南
echo ========================================
echo.
echo 由于网络限制，无法自动安装JDK。
echo 请按照以下步骤完成系统启动:
echo.
echo ========================================
echo    当前状态
echo ========================================
echo.
echo [✓] 前端服务: 已启动
echo     地址: http://localhost:3000
echo.
echo [✓] 数据库: 已初始化
echo     密码: liuyang000
echo.
echo [✗] 后端服务: 未启动 (缺少JDK)
echo.
echo ========================================
echo    安装JDK (必需)
echo ========================================
echo.
echo 请手动下载并安装JDK 8:
echo.
echo 下载地址 (选择一个):
echo   1. https://adoptium.net/temurin8/
echo   2. https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html
echo.
echo 安装步骤:
echo   1. 下载 Windows x64 版本
echo   2. 运行安装程序
echo   3. 记住安装路径 (如 C:\Program Files\Java\jdk1.8.0_xxx)
echo.
echo 配置环境变量 (管理员PowerShell):
echo   [Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Java\jdk1.8.0_xxx", "Machine")
echo   $path = [Environment]::GetEnvironmentVariable("Path", "Machine")
echo   [Environment]::SetEnvironmentVariable("Path", "$path;C:\Program Files\Java\jdk1.8.0_xxx\bin", "Machine")
echo.
echo 验证安装:
echo   javac -version
echo.
echo ========================================
echo    启动后端服务
echo ========================================
echo.
echo 安装JDK后，运行以下命令启动后端:
echo.
echo   cd d:\Lunwen\rental-backend
echo   mvn spring-boot:run -s .mvn/settings.xml
echo.
echo 或双击运行: d:\Lunwen\start.bat
echo.
echo ========================================
echo    默认登录账号
echo ========================================
echo.
echo   用户名: admin    密码: admin123    (管理员)
echo   用户名: landlord1  密码: 123456     (房东)
echo   用户名: tenant1   密码: 123456     (租客)
echo.
pause
