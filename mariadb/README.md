1. 마리아 이미지 가져오기
docker pull mariadb

2. 실행하기
docker run --name mariadb \
-e MYSQL_ROOT_PASSWORD= \
-e MYSQL_DATABASE=RD_COMMON \
-e MYSQL_USER=cg \
-e MYSQL_PASSWORD= \
-p 4306:3306 -d mariadb:latest

3. 설치 버전
 - Ubuntu 20.04
 - MariaDB 10.5.9

3. 캐릭터셋 미설정시 디펄트 서버 설정(phpmyadmin에서 확인)
 UTF-8 Unicode (utf8mb4) 