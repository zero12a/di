## debian linux 10
# docker build  -t msafluentd .
# (포그라운드 실행/배포) docker run -i -t -p 8030:80 --name fluentd msafluentd
# (백그라운드 실행/배포) docker run -i -t -d -p 8030:80 --name fluentd msafluentd



FROM fluent/fluentd:v1.14

# user commend line arg
ARG TO_MYSQL_HOST
ARG TO_MYSQL_PORT
ARG TO_MYSQL_DBNM
ARG TO_MYSQL_UID
ARG TO_MYSQL_PWD

ARG ENTRYKIT_VERSION=0.4.0

# Use root account to use apk
USER root


##############################################
## package install
##############################################
RUN apk add mariadb-dev tzdata

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish
RUN apk add --no-cache --update --virtual .build-deps \
        sudo build-base ruby-dev \
 && sudo gem install fluent-plugin-mysql-bulk \
 && sudo gem sources --clear-all \
 && apk del .build-deps \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

# 엔트리킷 환경변수템플릿
WORKDIR /etc
RUN wget -O entrykit.tgz https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
RUN tar -xvzf entrykit.tgz
RUN rm entrykit.tgz
RUN mv entrykit /usr/local/bin
RUN entrykit --symlink

##############################################
## config os
##############################################
# time  set seoul
RUN cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime
RUN echo "Asia/Seoul" > /etc/timezone



##############################################
## config daemon
##############################################
RUN wget -O /fluentd/etc/fluent.conf.tmpl https://raw.githubusercontent.com/zero12a/di/master/msafluentd/fluent.conf.tmpl?1
#RUN ["chmod", "777", "/fluentd/etc/fluent.conf.tmpl"]
RUN ["chmod", "777", "/fluentd/etc/fluent.conf"]


USER fluent

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
EXPOSE 24224/udp
EXPOSE 24224/tcp



##############################################
## start
##############################################
ENTRYPOINT [ \
    "render", \
        "/fluentd/etc/fluent.conf", \
        "--", \
    "/bin/entrypoint.sh" \
]

CMD ["fluentd"]
