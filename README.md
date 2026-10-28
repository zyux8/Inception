*This project has been created as part of the 42 curriculum by ohaker.*

# Inception

## Description

Inception builds a small web infrastructure with Docker Compose. It consists of three separately built services: NGINX provides HTTPS, WordPress runs with PHP-FPM, and MariaDB stores WordPress data. The services communicate over a private Docker network. The site domain is `ohaker.42.fr`.

Persistent WordPress and MariaDB data uses Docker named volumes configured to store their data under `/home/$USER/data` on the host.

## Instructions

### Prerequisites

- Docker Engine with the Docker Compose plugin
- A Linux host or virtual machine
- The local secrets in `secrets/` and the environment configuration in `srcs/.env`

The secrets are intentionally excluded from Git. Keep them local and never commit credentials.

### Configure the domain

Make `ohaker.42.fr` resolve to the IP address of the machine running Docker. For local testing, add an entry to that machine's `/etc/hosts`, replacing `<VM_IP>` with its address:

```text
<VM_IP> ohaker.42.fr
```

Confirm resolution with `getent hosts ohaker.42.fr`.

### Build and run

From the repository root:

```sh
make
```

This creates the host data directories and builds and starts the services. The site is available at `https://ohaker.42.fr`. NGINX uses a self-signed certificate, so a browser warning is expected.

Useful Make targets:

- `make` or `make up`: build and start the services
- `make down`: stop and remove the containers and network; retain images and data
- `make clean`: remove the containers, network, and project images; retain persistent data
- `make restart`: stop and start the services
- `make logs`: follow service logs
- `make ps`: show service status

### Verification

Validate the Compose file and check service status:

```sh
cd srcs
docker compose config -q
docker compose ps
```

Check HTTPS from the Docker host:

```sh
curl -kI https://ohaker.42.fr
```

The `-k` option permits the self-signed certificate for this test. To check TLS protocol support, use `openssl s_client` with `-tls1_2` and `-tls1_3` against `ohaker.42.fr:443`.

To check persistence, create a test post in WordPress and upload a test image. Run `make down`, then `make` from the repository root. Confirm the post and image are still present. `make clean` also preserves data; do not remove the host data directories if you need to keep the site.

## Resources

- [Docker Compose documentation](https://docs.docker.com/compose/)
- [Docker volumes documentation](https://docs.docker.com/engine/storage/volumes/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [WordPress documentation](https://wordpress.org/documentation/)
- [MariaDB documentation](https://mariadb.com/kb/en/documentation/)
- [WP-CLI documentation](https://developer.wordpress.org/cli/commands/)

AI tools were used to review the project configuration against the subject, explain implicit Docker image tags, draft this README, and update the image tags and Makefile clean target. The resulting configuration and instructions should be understood and verified by the project author.
