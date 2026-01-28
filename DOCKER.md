# Docker 部署说明

## 快速开始

### 构建 Docker 镜像

```bash
docker build -t encrypt-labs .
```

### 运行容器

```bash
docker run -d -p 80:80 --name encrypt-labs-container encrypt-labs
```

或者指定自定义端口:

```bash
docker run -d -p 8080:80 --name encrypt-labs-container encrypt-labs
```

### 访问应用

浏览器访问: `http://localhost` (或 `http://localhost:8080` 如果使用了自定义端口)

默认登录凭据:
- 用户名: `admin`
- 密码: `123456`

## 容器管理

### 查看容器日志

```bash
docker logs -f encrypt-labs-container
```

### 停止容器

```bash
docker stop encrypt-labs-container
```

### 启动容器

```bash
docker start encrypt-labs-container
```

### 删除容器

```bash
docker rm -f encrypt-labs-container
```

### 删除镜像

```bash
docker rmi encrypt-labs
```

## 数据库信息

容器内的数据库配置:

- **数据库名**: `encryptDB`
- **用户名**: `bachang`
- **密码**: `1234567`
- **Root 密码**: `root123456`
- **主机**: `127.0.0.1` (容器内部)

## 进入容器

如需进入容器进行调试:

```bash
docker exec -it encrypt-labs-container /bin/bash
```

### 连接到 MySQL

在容器内:

```bash
mysql -u bachang -p1234567 encryptDB
```

或使用 root 用户:

```bash
mysql -u root -proot123456
```

## 服务说明

容器内运行的服务:

1. **Nginx** - Web 服务器 (端口 80)
2. **MySQL** - 数据库服务 (端口 3306,仅容器内部)
3. **PHP 8.1-FPM** - PHP 处理器

所有服务通过 Supervisor 进行管理和监控。

## 故障排查

### 查看服务状态

进入容器后执行:

```bash
supervisorctl status
```

### 重启服务

```bash
# 重启 Nginx
supervisorctl restart nginx

# 重启 PHP-FPM
supervisorctl restart php-fpm

# 重启 MySQL
supervisorctl restart mysql
```

### 查看服务日志

```bash
# Nginx 日志
tail -f /var/log/supervisor/nginx.log

# PHP-FPM 日志
tail -f /var/log/supervisor/php-fpm.log

# MySQL 日志
tail -f /var/log/supervisor/mysql.log
```

## 注意事项

1. 容器重启后数据库数据会丢失,如需持久化请使用 Docker 卷挂载
2. 生产环境建议修改默认密码
3. 如需外部访问 MySQL,需要在 `docker run` 时添加 `-p 3306:3306` 参数

## 数据持久化 (可选)

如需持久化 MySQL 数据:

```bash
docker run -d \
  -p 80:80 \
  -v mysql-data:/var/lib/mysql \
  --name encrypt-labs-container \
  encrypt-labs
```

这将创建一个名为 `mysql-data` 的 Docker 卷来存储数据库文件。
