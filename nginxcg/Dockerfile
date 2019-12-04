# docker build -t msacgnginx .
# (포그라운드 실행) docker run -i -t -p 8090:80 --name cgnginx msacgnginx
# (백그라운드 실행) docker run -i -t -d -p 8090:80 --name cgnginx msacgnginx

FROM ubuntu:latest

# Install Nginx.
RUN apt-get update
RUN apt-get install -y nginx 

# Install debug tool
RUN apt-get install -y vim wget telnet

# conf copy
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