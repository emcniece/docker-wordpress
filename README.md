# emcniece/wordpress

Docker Hub: https://hub.docker.com/r/emcniece/wordpress/

From [WordPress](https://hub.docker.com/_/wordpress/), extended with [Nginx Helper](https://en-ca.wordpress.org/plugins/nginx-helper/) and [Redis Object Cache](https://en-ca.wordpress.org/plugins/redis-cache/) support.

Inherits regular setup from the [WordPress Docker image](https://hub.docker.com/_/wordpress/).

**PHP-FPM only** - requires a partner Nginx container to forward traffic to port 9000.

Injects environment variables prefixed with `WPFPM_` into `wp-config.php` during each container startup.

## Recommended Environment

The `docker-compose.yml` file injects 2 variables into `wp-config.php`:

```yml
WPFPM_WP_REDIS_HOST: redis # Name of the Redis container
WPFPM_RT_WP_NGINX_HELPER_CACHE_PATH: "/tmp/cache" # Set in wp-nginx.conf
```

## Quick Run

```
docker pull emcniece/wordpress
```

Update `docker-compose.yml` with local directory paths (to load `wp-nginx.conf` and `uploads.ini` properly), then execute:

```sh
docker-compose up -d
```

