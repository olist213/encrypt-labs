# Docker 部署说明

原始的docker镜像启动后产生3个容器，不方便ctfd靶场部署，特建立dockerfile。

## 快速开始

### 构建 Docker 镜像

```bash
docker build -t encrypt-labs .
```

### 运行容器

```bash
docker run -d -P --name encrypt-labs-container encrypt-labs
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
