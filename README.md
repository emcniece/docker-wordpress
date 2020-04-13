# emcniece/wordpress

Github: https://github.com/emcniece/docker-wordpress
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
    image: emcniece/wordpress:latest
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

Recognized environment variables:

- `ENABLE_HYPERDB`: Installs HyperDB config on first run, `[true|false]`
    - eg. `ENABLE_HYPERDB=true`
- `WP_PLUGINS`: space-separated plugin directory names, to be installed from the WP plugin marketplace
    - eg. `WP_PLUGINS="nginx-helper redis-cache"`
- `ENABLE_CRON`: Enables `crond` daemon in background (logs to container stdout)
    - eg. `ENABLE_CRON=true`
- `CRON_CMD`: Cron command to be added to `crontab` on startup
    - eg. `CRON_CMD="*/10 * * * * /usr/bin/ls -al /root"`


### Runtime ENV wp-config.php Injection

Any environment variables prefixed with `WPFPM_` will be injected into `wp-config.php` during each container startup. **Warning:** this means that `wp-config.php` is regenerated each restart using the provided environment variables.

The provided `docker-compose.yml` file injects 2 variables into `wp-config.php`:

```yml
WPFPM_WP_REDIS_HOST: redis # Name of the Redis container
WPFPM_RT_WP_NGINX_HELPER_CACHE_PATH: "/tmp/cache" # Set in emcniece/nginx-cache-purge-wp default.conf
```

### HyperDB Configuration

The HyperDB drop-in allows a replica database to be configured alongside the primary database.

When `ENABLE_HYPERDB=true` the HyperDB config files will be copied into place and will override the database config provided in `wp-config.php`. The HyperDB replica database can be configured with the following environment variables:

- `REPLICA_DB_HOST`
- `REPLICA_DB_USER`
- `REPLICA_DB_PASSWORD`
- `REPLICA_DB_NAME`


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

## To Do

- [x] Imagick / LibZip PHP Extensions (courtesy of `wordpress:5-php7.2-fpm-alpine`)
- [ ] HyperDB config: allow read/write to be set for both primary and replica databases
- [ ] HyperDB config: replace current ENV vars with `WPFPM_` injection pattern
