## debian linux 10 (/etc/issue, /etc/debian_version)
# docker build -t msaredis .
# docker run -d -p 1234:6379 --name redis msaredis

#검증버전 ; 4.0.2, 최신버전 : 6.0.5
FROM redis 
#FROM redis:6.2.4-alpine3.13


ARG ENTRYKIT_VERSION=0.4.0

RUN apt-get update            
RUN apt-get install -y curl unzip wget sudo

# Install debug tool (vi:bim, ps:procps, netstat:net-tools)
RUN apt-get install -y vim telnet procps net-tools


# 엔트리킷 환경변수템플릿
RUN mkdir /usr_data
RUN chmod 755 /usr_data
WORKDIR /usr_data
RUN wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
RUN tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
RUN rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
RUN mv entrykit /usr/local/bin
RUN entrykit --symlink


# redis.conf 가져오기
WORKDIR /usr_data
RUN wget https://raw.githubusercontent.com/zero12a/di/master/db/msaredis/redis.conf.tmpl

# redis 비밀번호 설정하기
ENV REDIS_PASSWD "1234"

# 렌더링하기
ENTRYPOINT [ \
    "render", \
        "/usr_data/redis.conf", \
        "--", \
    "/usr/local/bin/redis-server", \
        "/usr_data/redis.conf" \
]
