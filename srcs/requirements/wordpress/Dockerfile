FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
	php8.2-fpm php8.2-cli php8.2-mysql php8.2-curl php8.2-gd \
	php8.2-mbstring php8.2-xml php8.2-zip \
	mariadb-client curl ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://wordpress.org/latest.tar.gz | tar xz -C /usr/src

RUN curl -fsSL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	-o /usr/local/bin/wp \
	&& chmod +x /usr/local/bin/wp

RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' \
	/etc/php/8.2/fpm/pool.d/www.conf \
	&& sed -i 's|^;clear_env = no|clear_env = no|' \
	/etc/php/8.2/fpm/pool.d/www.conf \
	&& mkdir -p /run/php /var/www/html \
	&& printf 'upload_max_filesize=64M\npost_max_size=64M\nmemory_limit=256M\n' \
	> /etc/php/8.2/fpm/conf.d/99-wordpress.ini

COPY tools/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR /var/www/html
EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["php-fpm8.2", "-F"]
