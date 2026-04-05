@echo off
chcp 65001 >nul
echo ========================================
echo    JDK 8 手动安装指南
echo ========================================
echo.
echo 由于网络限制，无法自动下载JDK。
echo 请按照以下步骤手动安装:
echo.
echo ========================================
echo    步骤1: 下载JDK 8
echo ========================================
echo.
echo 请访问以下任一网站下载JDK 8:
echo.
echo 方案A: Oracle官网 (需要登录)
echo   https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html
echo   选择 "Windows x64" 版本
echo   下载 jdk-8uXXX-windows-x64.exe
echo.
echo 方案B: Adoptium (推荐， 无需登录)
echo   https://adoptium.net/temurin8/
echo   选择 "Windows x64" 版本
echo   下载 .msi 或 . .exe 安装包
echo.
echo ========================================
echo    步骤2: 安装JDK
echo ========================================
echo.
echo 1. 双击下载的安装包
echo 2. 按照安装向导完成安装
echo 3. 记住安装路径
echo    默认路径: C:\Program Files\Java\jdk1.8.0_xxx
echo    或自定义路径
echo.
echo ========================================
echo    步骤3: 配置环境变量
echo ========================================
echo.
echo 安装完成后，需要配置环境变量。
echo.
echo 方法一: 通过系统属性配置 (推荐)
echo   1. 右键"此电脑" - " 属性"
echo   2. 点击"高级系统设置"
echo   3. 点击"环境变量"
echo   4. 新建系统变量:
echo      - 变量名: JAVA_HOME
echo      - 变量值: C:\Program Files\Java\jdk1.8.0_xxx
echo   5. 编辑Path变量， 添加: ;%JAVA_HOME%\bin
echo.
echo 方法二: 通过命令行配置 (管理员权限)
echo   以echo # 设置JAVA_HOME (替换实际路径)
echo [Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Java\jdk1.8.0_xxx", "Machine")
echo.
echo # 添加到PATH
echo $path = [Environment]::GetEnvironmentVariable("Path", "Machine")
echo [Environment]::SetEnvironmentVariable("Path", "$path;C:\Program Files\Java\jdk1.8.0_xxx\bin", "Machine")
echo.
echo ========================================
echo    步骤4: 验证安装
echo ========================================
echo.
echo 关闭所有命令行窗口
重新打开后运行:
echo   java -version
echo   javac -version
echo.
echo 两个命令都应该显示版本信息才算成功!
echo.
echo ========================================
echo    步骤5: 继续启动后端
echo ========================================
echo.
echo 安装JDK后，请告诉我安装路径
echo 我将帮你继续启动后端服务！echo.
pause
