FROM wordpress:4-php7.1-fpm-alpine

RUN apk --no-cache add openssl

ENV PHPREDIS_VERSION=3.1.2 \
    CONFIG_VAR_FLAG=WPFPM_ \
    PAGER=more \
    WP_PLUGINS="nginx-helper redis-cache"

RUN docker-php-source extract \
  && curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz \
  && tar xfz /tmp/redis.tar.gz \
  && rm -r /tmp/redis.tar.gz \
  && mv phpredis-$PHPREDIS_VERSION /usr/src/php/ext/redis \
  && docker-php-ext-install redis \
  && docker-php-source delete

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp

ADD uploads.ini /usr/local/etc/php/conf.d/
ADD .bashrc /root
COPY docker-entrypoint2.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint2.sh"]
CMD ["php-fpm"]