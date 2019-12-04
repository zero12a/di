# docker build -t msacgnginx .
# (포그라운드 실행) docker run -i -t -p 8090:80 --name cgnginx msacgnginx
# (백그라운드 실행) docker run -i -t -d -p 8090:80 --name cgnginx msacgnginx

FROM ubuntu:latest

# 작업폴더 만들기
RUN mkdir /data
RUN mkdir /data/www

# Install Nginx.
RUN apt-get update
RUN apt-get install -y nginx 

# Install debug tool
RUN apt-get install -y vim wget telnet

# 엔트리킷 환경변수템플릿
WORKDIR /data
RUN wget https://github.com/progrium/entrykit/releases/download/v0.4.0/entrykit_0.4.0_Linux_x86_64.tgz
RUN tar -xvzf entrykit_0.4.0_Linux_x86_64.tgz
RUN rm entrykit_0.4.0_Linux_x86_64.tgz
RUN mv entrykit /usr/local/bin
RUN entrykit --symlink

# conf copy
WORKDIR /data
RUN wget 
COPY nginx.conf /etc/nginx/nginx.conf

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