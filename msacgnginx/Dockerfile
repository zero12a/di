# docker build -t msacgnginx .
# (포그라운드 실행) docker run -i -t -p 8090:80 --name cgnginx msacgnginx
# (백그라운드 실행) docker run -i -t -d -p 8090:80 --name cgnginx msacgnginx
# nginx config 수정시 재시작 : nginx -s reload

FROM ubuntu:latest

# 작업폴더 만들기
RUN mkdir /data
RUN mkdir /data/www

# Install Nginx.
RUN apt-get update
RUN apt-get install -y nginx unzip

# Install debug tool
RUN apt-get install -y vim wget telnet

###################################################
# download libs
###################################################
RUN mkdir /data/www/lib
WORKDIR /data/www/lib
# 10. codemirror
RUN wget https://codemirror.net/codemirror.zip
RUN unzip codemirror.zip
RUN rm codemirror.zip
RUN mv codemirror*/ codemirror/
# 20. bootstrap4
RUN wget https://github.com/twbs/bootstrap/releases/download/v4.4.1/bootstrap-4.4.1-dist.zip
RUN unzip bootstrap-4.4.1-dist.zip
RUN rm bootstrap-4.4.1-dist.zip
RUN mv mv bootstrap-4.4.1-dist/ bootstrap4/
# 30. bootstrap4 jquery3 slim
RUN wget https://code.jquery.com/jquery-3.4.1.min.js
RUN mv jquery-3.4.1.min.js bootstrap4/
# 40. bootstrap4 popper.js
RUN wget https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js
RUN mv popper.min.js bootstrap4/
# 50. jquery
RUN mkdir /data/www/lib/jquery

RUN wget https://code.jquery.com/jquery-1.12.4.min.js
RUN mv jquery-1.12.4.min.js jquery/

RUN wget https://code.jquery.com/jquery-3.4.1.min.js
RUN mv jquery-3.4.1.min.js jquery/

RUN wget https://jqueryui.com/resources/download/jquery-ui-1.12.1.zip
RUN unzip jquery-ui-1.12.1.zip
RUN rm jquery-ui-1.12.1.zip
RUN mv jquery-ui-1.12.1/jquery-ui.min.* jquery/
RUN rm -rf jquery-ui-1.12.1

RUN wget https://raw.githubusercontent.com/dobtco/jquery-resizable-columns/gh-pages/dist/jquery.resizableColumns.min.js
RUN wget https://raw.githubusercontent.com/dobtco/jquery-resizable-columns/gh-pages/dist/jquery.resizableColumns.css
RUN mv jquery.resizableColumns.* jquery/
# 60. chart.js
RUN wget https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.3/Chart.min.js
# 70. feather
RUN wget https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.24.1/feather.min.js
RUN wget https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.24.1/feather.min.js.map
# 80. hashmap.js
RUN wget https://raw.githubusercontent.com/flesler/hashmap/master/hashmap.js
# 90. jqPropertyGrid
RUN wget https://raw.githubusercontent.com/ValYouW/jqPropertyGrid/master/jqPropertyGrid.js
RUN wget https://raw.githubusercontent.com/ValYouW/jqPropertyGrid/master/jqPropertyGrid.css
# 100. moment.min.js
RUN wget https://momentjs.com/downloads/moment.min.js
# 110. json2.min.js
RUN wget https://cdnjs.cloudflare.com/ajax/libs/json2/20160511/json2.min.js


# 엔트리킷 환경변수템플릿
WORKDIR /data
RUN wget https://github.com/progrium/entrykit/releases/download/v0.4.0/entrykit_0.4.0_Linux_x86_64.tgz
RUN tar -xvzf entrykit_0.4.0_Linux_x86_64.tgz
RUN rm entrykit_0.4.0_Linux_x86_64.tgz
RUN mv entrykit /usr/local/bin
RUN entrykit --symlink

# conf copy
WORKDIR /etc/nginx/
RUN rm /etc/nginx/nginx.conf
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msacgnginx/nginx.conf.tmpl

# env define
ENV FASTCGI_PASS 172.17.0.1:9100

# conf make conf
ENTRYPOINT [ \
    "render", \
        "/etc/nginx/nginx.conf", \
        "--" \
]

RUN chown -R www-data:www-data /var/lib/nginx

# Define mountable directories.
VOLUME ["/data/www"]

# Define working directory.
WORKDIR /etc/nginx

# Define default command.
CMD ["nginx"]

# Expose ports.
EXPOSE 80
EXPOSE 443