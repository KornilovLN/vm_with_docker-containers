#!/bin/bash

# Копируем файлы Flask приложения в /app
mkdir -p /app
cp -r /shared_folder/app/* /app

# Устанавливаем зависимости Flask
pip3 install --upgrade pip
pip3 install flask requests numpy pandas

cd /shared_folder

# Собираем образ Docker
docker build -t my-flask-img /app

# Запускаем контейнер
docker run -d -p 8086:80 my-flask-img
