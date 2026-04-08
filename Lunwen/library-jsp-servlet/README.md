# 图书借阅系统（JSP + Servlet + JavaBean + JDBC）

## 技术栈
- JSP + Servlet + JavaBean
- JDBC + MySQL
- HTML5 + CSS3 + JavaScript + Bootstrap
- Session 用户认证

## 功能模块
- 用户管理：读者注册/登录/改密，管理员新增/删除读者
- 图书管理：管理员增删改，读者按书名/作者检索与详情查看
- 借阅归还：管理员登记借阅与归还，自动更新库存
- 逾期提醒：管理员查看逾期未还列表并人工提醒

## 数据库初始化
```bash
mysql -u root -p < sql/init.sql
```

## 运行方式
1. 配置数据库连接（默认读取 JVM 参数，默认值：
   - `db.url=jdbc:mysql://localhost:3306/library_db?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai`
   - `db.user=root`
   - `db.password=root`）
2. 打包：
```bash
mvn clean package
```
3. 将 `target/library-jsp-servlet.war` 部署到 Tomcat 9+。

## 默认管理员
- 用户名：`admin`
- 密码：`admin123`
