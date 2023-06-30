#!/bin/bash


echo "daemon off;" >> /etc/nginx/nginx.conf
service nginx start &
gunicorn --bind 0.0.0.0:8000 myproject.wsgi &
service postgresql start

sudo -u postgres psql -c "CREATE USER django_user WITH PASSWORD 'django_password'"
sudo -u postgres psql -c "CREATE DATABASE django_db"

python3 manage.py makemigrations
python3 manage.py migrate

DJANGO_SUPERUSER_PASSWORD=admin ./manage.py createsuperuser \
    --no-input \
    --username=admin \
    --email=admin@domain.com

wait -n

exit 0


