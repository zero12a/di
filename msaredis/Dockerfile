docker run -d -p 7379:6379 --name redis1 redis


FROM redis


ARG ENTRYKIT_VERSION=0.4.0

RUN apt-get update            
RUN apt-get install -y curl unzip wget sudo

# Install debug tool (vi:bim, ps:procps, netstat:net-tools)
RUN apt-get install -y vim telnet procps net-tools


# 엔트리킷 환경변수템플릿
WORKDIR /data
RUN wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
RUN tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
RUN rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
RUN mv entrykit /usr/local/bin
RUN entrykit --symlink


# redis.conf 가져오기
RUN wget https://github.com/zero12a/di/archive/master.zip

