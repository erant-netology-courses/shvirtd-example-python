#!/bin/sh
# .gitignore в любом случае
# 1. Запускать, прокидывая параметры через экспортированные переменные
# 2. Запустить на месте с прокинутыми переменными
# 3. Gроинициализировать переменные из соседнего .env через баш скрипт, который запустит этот баш скрипт и прокинет в него переменные
# 4. Монтировать файл с секретами
# 5. .env как тут
now=$(date +"%s_%Y-%m-%d")

BACKUP_DIR="/opt/backup"
sudo mkdir -p "$BACKUP_DIR"

sudo docker run --rm \
  --entrypoint "" \
  --network=shvirtd-example-python_backend \
  --env-file .env \
  -e MYSQL_HOST=db \
  schnitzler/mysqldump:latest \
  sh -c 'mysqldump --opt -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" --ssl-mode=DISABLED --default-auth=mysql_native_password' \
  > ${BACKUP_DIR}/${now}_${MYSQL_DATABASE}.sql 2>&1

# cron:
# * * * * * /home/admin/netology_docker/shvirtd-example-python/backup.sh
