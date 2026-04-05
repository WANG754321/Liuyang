# 小区租房系统

## 项目简介
基于 Spring Boot 2.7 + Vue 3 + MySQL 8.0 的最小化技术栈小区租房系统。

## 技术栈

### 后端
- Spring Boot 2.7.18
- MyBatis-Plus 3.5.3.1
- MySQL 8.0
- Lombok

### 前端
- Vue 3.2
- Vue Router 4
- Element Plus 2.2
- Axios
- Vite 2.9

## 环境要求

| 软件 | 版本要求 | 检查命令 |
|------|----------|----------|
| JDK | 1.8+ | `java -version` |
| Maven | 3.6+ | `mvn -v` |
| MySQL | 8.0+ | `mysql --version` |
| Node.js | 14+ | `node -v` |

## 项目结构

```
Lunwen/
├── rental-backend/           # 后端项目
│   ├── sql/                  # 数据库脚本
│   │   └── init.sql
│   ├── src/main/java/com/rental/
│   │   ├── RentalApplication.java
│   │   ├── common/           # 通用类
│   │   ├── controller/       # 控制器
│   │   ├── entity/           # 实体类
│   │   ├── mapper/           # Mapper接口
│   │   └── service/          # 服务层
│   ├── init-db.bat           # 数据库初始化脚本
│   └── pom.xml
│
├── rental-frontend/          # 前端项目
│   ├── src/
│   │   ├── main.js
│   │   ├── App.vue
│   │   ├── router/           # 路由配置
│   │   ├── utils/            # 工具类
│   │   └── views/            # 页面组件
│   ├── index.html
│   ├── package.json
│   └── vite.config.js
│
├── start.bat                 # 一键启动脚本
└── README.md
```

## 快速开始

### 步骤1: 安装JDK（必需）

系统需要JDK才能编译运行后端代码。

**下载地址：**
- Oracle JDK: https://www.oracle.com/java/technologies/downloads/
- OpenJDK (推荐): https://adoptium.net/

**安装后配置环境变量：**
```powershell
# 设置JAVA_HOME（替换为你的JDK安装路径）
[Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Java\jdk1.8.0_xxx", "User")

# 添加到PATH
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";%JAVA_HOME%\bin", "User")
```

**验证安装：**
```bash
java -version
javac -version
```

### 步骤2: 初始化数据库

1. 确保MySQL服务已启动
2. 双击运行 `rental-backend/init-db.bat`
3. 输入MySQL root密码

或手动执行：
```bash
mysql -u root -p < rental-backend/sql/init.sql
```

### 步骤3: 修改数据库配置

编辑 `rental-backend/src/main/resources/application.yml`：
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/rental_db?useUnicode=true&characterEncoding=utf-8&serverTimezone=Asia/Shanghai
    username: root
    password: 你的MySQL密码
```

### 步骤4: 启动服务

**方式一：一键启动**
双击运行 `start.bat`

**方式二：分别启动**

启动后端：
```bash
cd rental-backend
mvn spring-boot:run -s .mvn/settings.xml
```

启动前端：
```bash
cd rental-frontend
npm install
npm run dev
```

### 步骤5: 访问系统

- 前端地址: http://localhost:3000
- 后端地址: http://localhost:8080

## 默认账号

| 用户名 | 密码 | 角色 |
|--------|------|------|
| admin | admin123 | 管理员 |
| landlord1 | 123456 | 房东 |
| tenant1 | 123456 | 租客 |

## 功能模块

### 用户模块
- 用户登录/注册
- 用户信息管理
- 角色权限（管理员、房东、租客）

### 房屋模块
- 房屋列表展示
- 房屋搜索
- 房屋详情查看
- 房东发布/管理房源

### 订单模块
- 租客预约看房
- 房东确认订单
- 订单状态管理
- 订单取消

## API接口

### 用户接口
- POST /api/user/login - 用户登录
- POST /api/user/register - 用户注册
- GET /api/user/{id} - 获取用户信息
- PUT /api/user - 更新用户信息

### 房屋接口
- GET /api/house/list - 获取房屋列表
- GET /api/house/page - 分页查询
- GET /api/house/{id} - 获取房屋详情
- GET /api/house/search - 搜索房屋
- GET /api/house/landlord/{landlordId} - 获取房东房源
- POST /api/house - 添加房屋
- PUT /api/house - 更新房屋
- DELETE /api/house/{id} - 删除房屋

### 订单接口
- GET /api/order/list - 获取订单列表
- GET /api/order/page - 分页查询
- GET /api/order/{id} - 获取订单详情
- GET /api/order/tenant/{tenantId} - 获取租客订单
- GET /api/order/landlord/{landlordId} - 获取房东订单
- POST /api/order - 创建订单
- PUT /api/order/confirm/{id} - 确认订单
- PUT /api/order/cancel/{id} - 取消订单

## 常见问题

### Q: 后端启动报错 "No compiler is provided"
**A:** 系统只安装了JRE，需要安装JDK。请参考步骤1安装JDK。

### Q: 前端启动报错 "Unexpected token"
**A:** Node.js版本过低，需要升级到14+版本。

### Q: 数据库连接失败
**A:** 检查MySQL服务是否启动，密码是否正确，数据库是否已初始化。

### Q: 登录提示"用户名或密码错误"
**A:** 确保数据库已初始化，使用默认账号登录。
