# emcniece/wordpress

Docker Hub: https://hub.docker.com/r/emcniece/wordpress/

From [WordPress](https://hub.docker.com/_/wordpress/), extended with [Nginx Helper](https://en-ca.wordpress.org/plugins/nginx-helper/) and [Redis Object Cache](https://en-ca.wordpress.org/plugins/redis-cache/) support.

Inherits regular setup from the [WordPress Docker image](https://hub.docker.com/_/wordpress/).

**PHP-FPM only** - requires a partner Nginx container to forward traffic to port 9000.

## Recommended Environment

The `docker-compose.yml` file injects 2 variables into `wp-config.php`:

```yml
WPFPM_WP_REDIS_HOST: redis # Name of the Redis container
WPFPM_RT_WP_NGINX_HELPER_CACHE_PATH: "/tmp/cache" # Set in wp-nginx.conf
```

Any environment variables prefixed with `WPFPM_` will be injected into `wp-config.php` during each container startup. **Warning:** this means that `wp-config.php` is regenerated each restart using the provided environment variables.


## Quick Run

If you want to use the standalone FPM (port 9000) image:

```
docker run -td \
  -v ./html:/var/www/html \
  emcniece/wordpress:4-php7.1-fpm-alpine
```

If you want to run a full web-accessible stack (Nginx, WP-FPM, MySQL, Redis):

```sh
docker-compose up -d
```
