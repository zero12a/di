## 설정 순서
docker run -d --name rabbitmq -p 15674:15674 -p 15672:15672 -p 5672:5672 -p 5671:5671 -e RABBITMQ_DEFAULT_USER=test -e RABBITMQ_DEFAULT_PASS=1234 rabbitmq:4.1-alpine

# 설정파일 경로(도커 이미지 내에서)
/etc/rabbitmq/conf.d/*.conf
loopback_users = none #원격 접속 허용

# 플러그인cli명령으로 rabbitmq 모듈 추가 설치
rabbitmq-plugins enable rabbitmq_web_stomp
//정상 추가여부 확인
/etc/rabbitmq# cat enabled_plugins 
[rabbitmq_prometheus,rabbitmq_web_stomp].



< 그외 것들 >
#컨테이너를 이미지로 백업
docker commit containernm imagenm

# port 15674 websocket

# PhpAmqpLib로 접근시 
dokcer run시 5671port열지 않으면 아래와 같이 오류 발생
Fatal error: Uncaught PhpAmqpLib\Exception\AMQPRuntimeException: Error reading data. Received 0 instead of expected 1 bytes

# loopback 설정안하면 다음에러 발생
Fatal error: Uncaught PhpAmqpLib\Exception\AMQPRuntimeException: Error Connecting to server(111): Connection refused


# vi/netstat 설치
apt-get update
apt-get install -y vim net-tools

# php lib필요 (phpinfo에서 bcmath 설치여부확인하기)
composer require php-amqplib/php-amqplib

apk add php7-bcmath
docker-php-ext-install bcmath




# 메시지큐의 내용 조회
