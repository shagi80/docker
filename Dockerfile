FROM ubuntu:20.04

# установка nginx
RUN apt update && apt install -y nginx curl nano sudo

# установка python и pip
RUN apt install -y python-is-python3 python3-pip

# переменные окружения
# не записывать .рус файлы
ENV PYTHONDONTWRITEBYTECODE 1
# отключение буферизации потоков stdout и stderr
ENV PYTHONUNBUFFERED 1

# установка timezone
ENV TZ=Eurpe/Moscow DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install tzdata

# установка Progress и зависимостей
RUN apt install -y python3-dev libpq-dev postgresql postgresql-contrib gcc

# создание рабочей дирректории внутри контейнера
ENV APP_DIR /my_django
RUN mkdir -p $APP_DIR

# копирование проекта и файла зависимостей
COPY ./nginx/mysite.conf /etc/nginx/sites-enabled/default
COPY ./my_django $APP_DIR

# установка Django и зависимостей
RUN pip install --upgrade pip
RUN pip install -r $APP_DIR/requirements.txt

WORKDIR $APP_DIR
VOLUME $APP_DIR

EXPOSE 80

ENTRYPOINT ["bash", "./start.sh"]
