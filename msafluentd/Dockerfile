FROM fluent/fluentd:v1.12-1

ARG TO_MYSQL_HOST
ARG TO_MYSQL_PORT
ARG TO_MYSQL_DBNM
ARG TO_MYSQL_UID
ARG TO_MYSQL_PWD

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

##############################################
## config os
##############################################
# time  set seoul
RUN cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime
RUN echo "Asia/Seoul" > /etc/timezone



##############################################
## config daemon
##############################################
RUN wget -O /fluent.conf.tmpl https://raw.githubusercontent.com/zero12a/di/master/msafluentd/fluent.conf.tmpl



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
