FROM debian:bookworm

RUN apt-get update &&\
	apt-get upgrade -y &&\
	apt-get install mariadb-server -y &&\
	rm -rf /var/lib/apt/lists/*

COPY conf/99-inception.cnf /etc/mysql/mariadb.conf.d/99-inception.cnf
COPY tools/init.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/init.sh"]
