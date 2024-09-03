#!/bin/sh

if ["$DATABASE" = "postgres"]
then
	echo "Waiting for postgres..."
	
	while ! nc -z $DB_HOST 5432; do
	    sleep 0.1
	done
	echo "Postgres started"

fi

python manage.py flush --no-input
python manage.py migrate

exec "$@"
