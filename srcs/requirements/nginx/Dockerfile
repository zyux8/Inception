FROM debian:bookworm

RUN apt-get update &&\
	apt-get upgrade -y &&\
	apt-get install nginx openssl -y &&\
	rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY index.html /var/www/html/index.html

EXPOSE 443

RUN mkdir -p /etc/nginx/ssl && openssl req -x509 -newkey rsa:2048 -nodes -keyout /etc/nginx/ssl/inception.key -out /etc/nginx/ssl/inception.crt -days 365 -subj "/CN=ohaker.42.fr"

CMD ["nginx"]
