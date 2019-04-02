FROM php:7.1-apache

# install the PHP extensions we need
RUN set -ex; \
	\
	if command -v a2enmod; then \
		a2enmod rewrite; \
	fi; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libjpeg-dev \
		libpng-dev \
		libpq-dev \
	; \
	\
	docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
	docker-php-ext-install -j "$(nproc)" \
		gd \
		opcache \
		pdo_mysql \
		pdo_pgsql \
		zip \
	; \
	\
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
		| awk '/=>/ { print $3 }' \
		| sort -u \
		| xargs -r dpkg-query -S \
		| cut -d: -f1 \
		| sort -u \
		| xargs -rt apt-mark manual; \
	\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

WORKDIR /var/www/html

# https://www.drupal.org/node/3060/release
ENV DRUPAL_VERSION 8.6.13
ENV DRUPAL_MD5 ded84151ebda80826f18e924dab03edd

RUN curl -fSL "https://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz \
	&& echo "${DRUPAL_MD5} *drupal.tar.gz" | md5sum -c - \
	&& tar -xz --strip-components=1 -f drupal.tar.gz \
	&& rm drupal.tar.gz \
	&& chown -R www-data:www-data sites modules themes

# vim:set ft=dockerfile:

#end php-apache image


ENV TERM=xterm

RUN apt-get update \
     && apt-get upgrade -y \
     && apt-get install -y --no-install-recommends \
          ssmtp \
          vim \
          sudo \ 
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/*

RUN { echo 'sendmail_path = "/usr/sbin/sendmail -t -i"'; } >> /usr/local/etc/php/php.ini

# sudo required for php composer to run as www-data
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# build rpaf from github source
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y build-essential apache2-dev unzip git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/local/opt/rpaf 
ADD https://github.com/gnif/mod_rpaf/archive/stable.zip /usr/local/opt/rpaf
RUN cd /usr/local/opt/rpaf && unzip stable.zip
RUN cd /usr/local/opt/rpaf/mod_rpaf-stable && make && make install
ADD src/rpaf.load /etc/apache2/mods-available
ADD src/rpaf.conf /etc/apache2/mods-available

RUN apt-get remove -y --purge build-essential apache2-dev unzip

ADD src/startApache.sh /usr/local/bin
RUN chmod +x /usr/local/bin/startApache.sh

CMD ["/usr/local/bin/startApache.sh"]

