## debian linux 10
# docker build  -t msalc2 .

# step 1
FROM alpine:3.13.1

# 외부에서 값 받음
ARG TO_MYSQL_HOST
ARG TO_MYSQL_PORT
ARG TO_MYSQL_DBNM
ARG TO_MYSQL_UID
ARG TO_MYSQL_PWD

ARG ENTRYKIT_VERSION=0.4.0

##############################################2
## install os package
##############################################
# cron, vi, procps(ps) 은 처음부터 설치되어 있음, 
# libpq-dev는 postgresql-dev로 변경
# telnet은 busybox-extras로 변경
# tzdata는 타임존데이터
# apuc컴파일 위해 autoconf, build-base(gcc) 필요
RUN apk update && apk upgrade
RUN apk add curl unzip wget sudo net-tools busybox-extras autoconf mysql-dev libzip-dev tzdata bash

#whereis는 util-linux에 
RUN apk add --update util-linux

#rsyslog 설치
RUN apk add rsyslog rsyslog-mysql


##############################################
## config os
##############################################
# time  set seoul
RUN cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime
RUN echo "Asia/Seoul" > /etc/timezone


##############################################
## make folder
##############################################
RUN mkdir /data
RUN mkdir /data/www

#RUN chmod 777 /data/www/log



##############################################
## install apps package
##############################################
# install download lib

# 엔트리킷 환경변수템플릿
WORKDIR /data
RUN wget -O entrykit.tgz https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
RUN tar -xvzf entrykit.tgz
RUN rm entrykit.tgz
RUN mv entrykit /usr/local/bin
RUN entrykit --symlink


##############################################
## install apps config
##############################################
# 사용자 변경하기 (서비스 설정파일 및 app소스 일일)
# rsyslog.conf 가져오기
RUN wget -O /etc/rsyslog.conf.tmpl https://raw.githubusercontent.com/zero12a/di/master/msalc2/rsyslog.conf.tmpl


##############################################
## application
##############################################


##############################################
## 불필요 패키지/데이터 삭제하기
##############################################
RUN apk del build-base tzdata autoconf libzip-dev

# down entrypoint.sh
RUN wget -O /entrypoint.sh https://raw.githubusercontent.com/zero12a/di/master/msalc2/entrypoint.sh?5
RUN ["chmod", "+x", "/entrypoint.sh"]



##############################################
## application env
##############################################
### env define
ENV TO_MYSQL_HOST   =   $TO_MYSQL_HOST
ENV TO_MYSQL_PORT   =   $TO_MYSQL_PORT
ENV TO_MYSQL_DBNM   =   $TO_MYSQL_DBNM
ENV TO_MYSQL_UID    =   $TO_MYSQL_UID
ENV TO_MYSQL_PWD    =   $TO_MYSQL_PWD

# port open
EXPOSE 514/udp
EXPOSE 514/tcp

# conf make conf
##############################################
## start
##############################################
ENTRYPOINT [  \
    "render", \
        "/etc/rsyslog.conf", \
        "--", \
    "/entrypoint.sh" \
]
