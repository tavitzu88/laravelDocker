FROM php:8.1-fpm-bookworm

USER root

ARG USER_ID
ARG GROUP_ID

RUN userdel -f www-data
RUN if getent group www-data ; then groupdel www-data; fi
RUN if ! getent group ${GROUP_ID} ; then groupadd -g ${GROUP_ID} www-data ; else groupmod -n www-data $(getent group ${GROUP_ID} | cut -d: -f1); fi
RUN useradd -l -u ${USER_ID} -g www-data www-data
RUN chown -R www-data:www-data /var/www

RUN install -d -m 0755 -o www-data -g www-data /home/www-data
RUN chown -R www-data:www-data /home/www-data

RUN mkdir /var/log/supervisor
RUN chown -R www-data:www-data /var/log/supervisor
RUN touch /var/run/supervisord.pid
RUN touch /var/run/crond.pid
RUN chown -R www-data:www-data /var/run
RUN chown www-data:www-data /var/run/supervisord.pid /var/run/crond.pid

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash -

RUN apt-get update && apt-get install -y \
    cron \
    default-mysql-client \
    git \
    gnupg \
    gzip \
    libbz2-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libonig-dev \
    libpng-dev \
    libsodium-dev \
    libssh2-1-dev \
    libwebp-dev \
    libxslt1-dev \
    libzip-dev \
    lsof \
    mailutils \
    msmtp \
    nodejs \
    procps \
    strace \
    vim \
    zip \
    zlib1g-dev \
    nano \
    logrotate \
  && rm -rf /var/lib/apt/lists/*

RUN pecl channel-update pecl.php.net && pecl install \
    redis-6.0.2 \
    xdebug-3.3.2 \
  && pecl clear-cache \
  && rm -rf /tmp/pear

RUN curl -L https://github.com/Imagick/imagick/archive/28f27044e435a2b203e32675e942eb8de620ee58.zip -o imagick.zip \
    && unzip imagick.zip \
    && rm imagick.zip \
    && cd imagick-28f27044e435a2b203e32675e942eb8de620ee58 \
    && phpize \
    && ./configure --with-php-config=/usr/local/bin/php-config \
    && make \
    && make install \
    && echo "extension=imagick.so" >> $PHP_INI_DIR/conf.d/imagick.ini \
    && cd .. \
    && rm -rf imagick-28f27044e435a2b203e32675e942eb8de620ee58

RUN docker-php-ext-configure \
    gd --with-freetype --with-jpeg --with-webp \
  && docker-php-ext-install \
    bcmath \
    bz2 \
    calendar \
    exif \
    gd \
    gettext \
    intl \
    mbstring \
    mysqli \
    opcache \
    pcntl \
    pdo_mysql \
    sockets \
    sodium \
    zip \
  && docker-php-ext-enable \
    imagick \
    redis \
    xdebug


RUN git clone --branch v0.4.15 --depth=1 https://github.com/NoiseByNorthwest/php-spx.git /usr/lib/php-spx \
    && cd /usr/lib/php-spx \
    && phpize \
    && ./configure \
    && make \
    && make install

RUN curl -sS https://getcomposer.org/installer | \
  php -- --install-dir=/usr/local/bin --filename=composer

COPY conf/spx.ini $PHP_INI_DIR/conf.d/spx.ini
COPY conf/msmtprc /etc/msmtprc
COPY conf/logrotate-laravel /etc/logrotate.d/laravel
RUN apt-get update && apt-get install -y supervisor
ADD conf/crontab /etc/cron.d/cron
RUN crontab -u www-data /etc/cron.d/cron

RUN usermod -a -G crontab www-data
RUN chmod gu+s /usr/sbin/cron

#RUN python3 -c "import socket as s; sock = s.socket(s.AF_UNIX); sock.bind('/dev/shm/supervisor.sock')"

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

WORKDIR /var/www/src
