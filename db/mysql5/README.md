1. 마리아 이미지 가져오기
docker pull mysql:5.7

2. 실행하기
docker run --name mysql \
-e MYSQL_ROOT_PASSWORD= \
-p 8306:3306 -d mysql:5.7

3. 설치 버전
 - OS : 
 - MariaDB : 5.7.36

3. 캐릭터셋 미설정시 디펄트 서버 설정(phpmyadmin에서 확인)
latin