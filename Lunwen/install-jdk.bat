@echo off
chcp 65001 >nul
echo ========================================
echo    JDK 安装指南
echo ========================================
echo.
echo 您的系统中只安装了JRE，没有安装JDK。
echo 后端项目无法编译运行。
echo.
echo ========================================
echo    方案一：下载安装 JDK 8
echo ========================================
echo.
echo 下载地址：
echo   - Oracle JDK 8: https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html
echo   - OpenJDK 8 (推荐): https://adoptium.net/temurin8/
echo.
echo 安装步骤：
echo   1. 下载 JDK 安装包
echo   2. 运行安装程序，按提示完成安装
echo   3. 记住安装路径(如 C:\Program Files\Java\jdk1.8.0_xxx)
echo.
echo ========================================
echo    方案二:配置环境变量
echo ========================================
echo.
echo 安装完成后，以管理员身份运行 PowerShell:
echo.
echo # 设置JAVA_HOME环境变量
echo [Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Java\jdk1.8.0_xxx", "Machine")
echo.
echo # 添加到PATH环境变量
echo $path = [Environment]::GetEnvironmentVariable("Path", "Machine")
echo [Environment]::SetEnvironmentVariable("Path", "$path;C:\Program Files\Java\jdk1.8.0_xxx\bin", "Machine")
echo.
echo ========================================
echo    方案三:验证安装
echo ========================================
echo.
echo 关闭所有命令行窗口，重新打开后运行:
echo   java -version
echo   javac -version
echo.
echo ========================================
echo    安装完成后继续
echo ========================================
echo.
echo 安装JDK后，请告诉我，我将帮你继续启动后端服务！
echo.
pause
