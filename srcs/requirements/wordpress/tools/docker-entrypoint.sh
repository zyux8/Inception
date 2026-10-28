#!/bin/bash
set -eu

. /run/secrets/credentials
WORDPRESS_DB_PASSWORD="$(< /run/secrets/db_password)"

WP=/var/www/html
WPCLI="wp --path=$WP --allow-root"

tries=0
until mariadb -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" \
              -p"$WORDPRESS_DB_PASSWORD" "$WORDPRESS_DB_NAME" \
              -e "SELECT 1" >/dev/null 2>&1; do
  tries=$((tries + 1))
  if [ "$tries" -ge 30 ]; then
    echo "MariaDB not reachable, giving up" >&2
    exit 1
  fi
  echo "Waiting for MariaDB..."
  sleep 2
done

if [ ! -e "$WP/wp-includes/version.php" ]; then
  cp -a /usr/src/wordpress/. "$WP/"
fi

if [ ! -e "$WP/wp-config.php" ]; then
  $WPCLI config create \
    --dbname="$WORDPRESS_DB_NAME" \
    --dbuser="$WORDPRESS_DB_USER" \
    --dbpass="$WORDPRESS_DB_PASSWORD" \
    --dbhost="$WORDPRESS_DB_HOST"
fi

if ! $WPCLI core is-installed; then
  $WPCLI core install \
    --url="https://$DOMAIN_NAME" \
    --title="$WP_TITLE" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASSWORD" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --skip-email

  $WPCLI user create "$WP_USER" "$WP_USER_EMAIL" \
    --user_pass="$WP_USER_PASSWORD" \
    --role=author
fi

chown -R www-data:www-data "$WP"

exec "$@"