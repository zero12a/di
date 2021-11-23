1. 마리아 이미지 가져오기
docker pull mysql:8

2. 실행하기
docker run --name mysql8 \
-e MYSQL_ROOT_PASSWORD= \
-p 8306:3306 -d mysql:8

3. 설치 버전
 - OS(cat /etc/issue) : Debian GNU/Linux 10
 - MariaDB : 8.0.27

3. 캐릭터셋 미설정시 디펄트 서버 설정(phpmyadmin에서 확인)
 UTF-8 Unicode (utf8mb4) 
 