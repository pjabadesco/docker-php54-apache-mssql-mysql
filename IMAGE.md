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

docker build -t pjabadesco/php54-apache-mssql-mysql:1.8 .
docker push pjabadesco/php54-apache-mssql-mysql:1.8

docker build -t pjabadesco/php54-apache-mssql-mysql:latest .
docker push pjabadesco/php54-apache-mssql-mysql:latest

## NEW

docker buildx build --platform=linux/amd64 --tag=php54-apache-mssql-mysql:latest --load .

docker tag php54-apache-mssql-mysql:latest pjabadesco/php54-apache-mssql-mysql:1.8
docker push pjabadesco/php54-apache-mssql-mysql:1.8

docker tag pjabadesco/php54-apache-mssql-mysql:1.8 pjabadesco/php54-apache-mssql-mysql:latest
docker push pjabadesco/php54-apache-mssql-mysql:latest

docker tag pjabadesco/php54-apache-mssql-mysql:latest ghcr.io/pjabadesco/php54-apache-mssql-mysql:latest
docker push ghcr.io/pjabadesco/php54-apache-mssql-mysql:latest
