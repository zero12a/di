1. mysql8 이미지 가져오기
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
 
4. group by 오류 방지
<mysql8 기본설정>
select @@sql_mode;
ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION

<mysql8 변경설정, /etc/mysql/my.cnf>

[mysqld]
...
sql_mode="STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTIO"

5. 기타
vim설치 : 
    apt-get update && apt-get install -y vim
