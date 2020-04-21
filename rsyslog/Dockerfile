############################
##  log server
############################
# 이미지 다운로드 (https://hub.docker.com/r/rsyslog/syslog_appliance_alpine/)
docker pull rsyslog/syslog_appliance_alpine

# 이미지 실행
docker run -i -t -d -p 514:514 -p 514:514/udp --name rsyslog rsyslog/syslog_appliance_alpine:latest 

# 쉘은 sh만 실행 가능
docker exec -it rsyslog sh

# 업데이트
apk update

# mysql연결 설치
apk add rsyslog-mysql

# mysql 저장 테이블 생성
https://github.com/rsyslog/rsyslog/blob/master/plugins/ommysql/createDB.sql

# mysql 해당 테이블에 모든 권한 부여
grant all privileges on RSYSLOG.* to cg@'%' identified by 'cg1234qwer'; 
flush privileges; 

# /etc/rsyslog.conf에 mysql 설정 추가
module(load="ommysql")
action(type="ommysql" server="mysqlserver.example.com" serverport="1234"
       db="syslog_db" uid="user" pwd="pwd")

############################
##  log client
############################
# ubuntu:18.04 기본이미지 64M

# 아래와 같이 logs 를 외부 전송시 logs stdout 조회는 안됨
docker logs rsyslog_client << 안됨

# 형식
docker run -i -t -d --name rsyslog_client \
 --log-driver=syslog \                                 # --log-driver : 로깅드라이버 설정, syslog 사용하겠다는 의미
 --log-opt syslog-address=tcp://172.17.0.1:514 \       # --log-opt : 로깅 드라이버에 추가할 옵션, syslog-address=[주소]
 --log-opt tag="mylog" \                               # --log-opt : 로깅 드라이버에 추가할 옵션, tag=[태그]   
 ubuntu:18.04

# 예시
docker run -i -t -d --name rsyslog_client1 \
 --log-driver=syslog \
 --log-opt syslog-address=tcp://172.17.0.1:514 \
 --log-opt tag="myclient1" \
  ubuntu:18.04


docker run -i -t -d --name rsyslog_client2 \
 --log-driver=syslog \
 --log-opt syslog-address=tcp://172.17.0.1:514 \
 --log-opt tag="myclient2" \
  ubuntu:18.04