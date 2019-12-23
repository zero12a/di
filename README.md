# di
docker images

# index
msacg : code generate
msalc : logger collector
msalib : javascript library
msapm : phpMyAdmin 
msaredis : redis server
msamysql : mysql server 5.7

# logstash 설치
docker pull docker.elastic.co/logstash/logstash:7.4.2

# logstash logstash.conf

input {  
  redis {
    host => "172.17.0.1"
    posg => "1234"
    data_type => "list"
    key => "plog"
    # batch_count => 1
    # threads => 1
  }
}
output { stdout { codec => dots } }

어서오세요
여기는 도커 이미지 관련 정보입니다.