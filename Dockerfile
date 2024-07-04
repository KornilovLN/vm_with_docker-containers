#---------------------------------------------------------------------
# образ Docker с тегом my-image, содержащий
# Ubuntu 20.04, Nginx, Python, Docker, Git и Midnight Commander.
# Файлы приложения Flask в директории app/
#---------------------------------------------------------------------
# docker build -t my-flask-img .        #--- сборка my-flask-img
# docker run -p 8086:80 my-image        #--- запустить контейнер
#
#---------------------------------------------------------------------

# Используем базовый образ Ubuntu 20.04
FROM ubuntu:20.04

# Обновляем список пакетов и устанавливаем необходимые пакеты
RUN apt-get update && \
    apt-get install -y nginx python3 python3-pip docker.io git mc && \
    rm -rf /var/lib/apt/lists/*

# Устанавливаем дополнительные пакеты Python через pip
RUN pip3 install --upgrade pip
RUN pip3 install flask requests numpy pandas

# Копируем файлы приложения в контейнер
COPY app/ /app/
COPY static/ /app/static
COPY templates/ /app/templates

# Устанавливаем рабочую директорию
WORKDIR /app

# Открываем порт для Nginx
EXPOSE 80

# Запускаем Nginx при старте контейнера
CMD ["nginx", "-g", "daemon off;"]

# Запускаем Flask приложение при старте контейнера
CMD ["python3", "app.py"]
