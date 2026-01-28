#!/bin/bash
set -e

echo "等待 MySQL 启动..."
sleep 5

# 检查 MySQL 是否已经启动
until mysqladmin ping -h localhost --silent; do
    echo "等待 MySQL 启动..."
    sleep 2
done

echo "MySQL 已启动,开始初始化数据库..."

# 设置 root 密码并创建数据库和用户
mysql -u root <<-EOSQL
    ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';
    CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE} CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost';
    GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
    FLUSH PRIVILEGES;
EOSQL

# 导入 SQL 文件
if [ -f /var/www/html/encryptDB.sql ]; then
    echo "导入 encryptDB.sql 文件..."
    mysql -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} < /var/www/html/encryptDB.sql
    echo "数据库导入完成!"
else
    echo "警告: encryptDB.sql 文件不存在!"
fi

echo "数据库初始化完成!"
