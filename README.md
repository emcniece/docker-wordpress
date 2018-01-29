# emcniece/wordpress

Docker Hub: https://hub.docker.com/r/emcniece/wordpress/

From [WordPress](https://hub.docker.com/_/wordpress/), extended with [Nginx Helper](https://en-ca.wordpress.org/plugins/nginx-helper/) and [Redis Object Cache](https://en-ca.wordpress.org/plugins/redis-cache/) support.

Inherits regular setup from the [WordPress Docker image](https://hub.docker.com/_/wordpress/).

**PHP-FPM only** - requires a partner Nginx container to forward traffic to port 9000.

## Installing Plugins

The `WP_PLUGINS` environment variable can be set to preload plugins into the `wp-content/plugins/` directory. By default it is set to `WP_PLUGINS="nginx-helper redis-cache"` as these plugins are core to the operation of this container. Plugins will only be installed the first time the container is run.

To add more plugins, modify the variable at runtime:

```sh
docker run -td \
  -v ./html:/var/www/html \
  -e "WP_PLUGINS=nginx-helper redis-cache mailgun my-other-plugin"
  emcniece/wordpress:4-php7.1-fpm-alpine
```

... or in [docker-compose.yml](./docker-compose.yml):

```yml
  wp-fpm:
    tty: true
    stdin_open: true
    image: emcniece/wordpress:0.0.2
    volumes:
      - wproot:/var/www/html
    environment:
      WORDPRESS_DB_HOST: mysql
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WPFPM_WP_REDIS_HOST: redis
      WPFPM_RT_WP_NGINX_HELPER_CACHE_PATH: "/tmp/cache"
      WP_PLUGINS: "nginx-helper redis-cache mailgun my-other-plugin"
```

## Recommended Environment

The `docker-compose.yml` file injects 2 variables into `wp-config.php`:

```yml
WPFPM_WP_REDIS_HOST: redis # Name of the Redis container
WPFPM_RT_WP_NGINX_HELPER_CACHE_PATH: "/tmp/cache" # Set in emcniece/nginx-cache-purge-wp default.conf
```

Any environment variables prefixed with `WPFPM_` will be injected into `wp-config.php` during each container startup. **Warning:** this means that `wp-config.php` is regenerated each restart using the provided environment variables.

### SSL Forwarding

The [docker-entrypoint2.sh](./docker-entrypoint2.sh) script also injects the PHP `HTTP_X_FORWARDED_PROTO` variable to allow for an SSL certificate to be terminated upstream while maintaining data communication into the container. This is useful in infrastructure with load balancers or reverse proxies, eg:

```
Internet -> Nginx proxy w/ SSL termination -> emcniece/nginx-cache-purge-wp -> emcniece/wordpress
```

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
