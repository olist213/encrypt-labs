FROM ubuntu:22.04

# 设置环境变量避免交互式安装
ENV DEBIAN_FRONTEND=noninteractive
ENV MYSQL_ROOT_PASSWORD=root123456
ENV MYSQL_DATABASE=encryptDB
ENV MYSQL_USER=bachang
ENV MYSQL_PASSWORD=1234567

# 更新系统并安装必要的软件包
RUN apt-get update && apt-get install -y \
    nginx \
    mysql-server \
    php8.1-fpm \
    php8.1-mysql \
    php8.1-cli \
    php8.1-common \
    php8.1-mbstring \
    php8.1-xml \
    php8.1-curl \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# 创建必要的目录
RUN mkdir -p /var/log/supervisor \
    && mkdir -p /run/php \
    && mkdir -p /var/www/html

# 复制项目文件到 web 根目录
COPY . /var/www/html/

# 设置文件权限
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# 复制 Nginx 配置文件
COPY docker/nginx.conf /etc/nginx/sites-available/default

# 复制 Supervisor 配置文件
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 复制数据库初始化脚本
COPY docker/init-db.sh /docker-entrypoint-initdb.d/init-db.sh
RUN chmod +x /docker-entrypoint-initdb.d/init-db.sh

# 暴露端口
EXPOSE 80 3306

# 启动脚本
COPY docker/start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
