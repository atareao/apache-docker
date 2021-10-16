FROM alpine:3.13

ENV TZ=Europe/Madrid

RUN apk add --update --no-cache \
    tini \
    libcap \
    tzdata \
    apache2 \
    apache2-ssl \
    curl \
    php8-apache2 \
    php8-bcmath \
    php8-bz2 \
    php8-calendar \
    php8-common \
    php8-ctype \
    php8-curl \
    php8-dom \
    php8-gd \
    php8-iconv \
    php8-mbstring \
    php8-mysqli \
    php8-mysqlnd \
    php8-openssl \
    php8-pdo \
    php8-pdo_mysql \
    php8-pdo_pgsql \
    php8-pdo_sqlite \
    php8-phar \
    php8-session \
    php8-tokenizer \
    php8-intl \
    php8-xmlwriter \
    php8-xml && \
    rm -rf /var/cache/apk && \
    addgroup -g 1000 -S dockeruser && \
    adduser -u 1000 -S dockeruser -G dockeruser&& \
    chown dockeruser:dockeruser /usr/sbin/crond && \
    setcap cap_setgid=ep /usr/sbin/httpd && \
    ln -s /usr/bin/php8 /usr/bin/php
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
COPY ./vhost.conf /etc/apache2/conf.d/
RUN chown -R dockeruser:dockeruser /etc/apache2/ \
                                   /etc/php8/ \
                                   /var/www/logs/ \
                                   /run/apache2/ \
                                   /etc/ssl/apache2/server.pem \
                                   /etc/ssl/apache2/server.key

COPY start.sh /start.sh

USER dockeruser
WORKDIR /htdocs

ENTRYPOINT ["tini", "--"]
CMD ["/bin/sh", "/start.sh"]
