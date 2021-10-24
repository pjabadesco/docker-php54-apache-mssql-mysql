## STEPS
docker system prune

docker-compose build
docker run -d -p 8080:80 pjabadesco/php54-apache-mssql-mysql

docker-compose up

docker run -d -p 8080:80 pjabadesco/php54-apache-mssql-mysql

docker-compose build --build-arg PATH_WWW='www'
docker push pjabadesco/php54-apache-mssql-mysql

docker stop live-app
docker rm live-app

docker build -t pjabadesco/php54-apache-mssql-mysql:1.2 .
docker push pjabadesco/php54-apache-mssql-mysql:1.2

docker build -t pjabadesco/php54-apache-mssql-mysql:latest .
docker push pjabadesco/php54-apache-mssql-mysql:latest
