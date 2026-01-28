#!/bin/bash
set -e

echo "启动 encrypt-labs 容器..."

# 初始化 MySQL 数据目录
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "初始化 MySQL 数据目录..."
    mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql
fi

# 启动 MySQL 服务
echo "启动 MySQL 服务..."
service mysql start

# 等待 MySQL 启动
sleep 5

# 执行数据库初始化脚本
echo "执行数据库初始化..."
/docker-entrypoint-initdb.d/init-db.sh

# 启动 PHP-FPM
echo "启动 PHP-FPM..."
service php8.1-fpm start

# 启动 Nginx
echo "启动 Nginx..."
service nginx start

echo "所有服务已启动!"
echo "访问地址: http://localhost"
echo "数据库信息:"
echo "  - 数据库名: ${MYSQL_DATABASE}"
echo "  - 用户名: ${MYSQL_USER}"
echo "  - 密码: ${MYSQL_PASSWORD}"
echo "  - Root 密码: ${MYSQL_ROOT_PASSWORD}"

# 使用 Supervisor 保持容器运行
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
