# Dockerfile for drupal8 with ssmtp to allow authenticated smtp 
# https://github.com/xmonit/drupal8-with-ssmtp

FROM drupal:8.3.5-apache

MAINTAINER Paul Cinnamond

ENV TERM=xterm

RUN apt-get update \
     && apt-get upgrade -y \
     && apt-get install -y --no-install-recommends \
          ssmtp \
          vim \
          sudo \ 
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/*

RUN { \
    echo '# docker xmonit/drupal8-with-ssmtp requires valid entries in /etc/ssmtp and sendmail path'; \
    echo 'sendmail_path = "/usr/sbin/sendmail -t -i"'; \
} >> /usr/local/etc/php/php.ini

# sudo required for php composer to run as www-data
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# distribution managed rpaf is old
#RUN apt-get update && apt-get install libapache2-mod-rpaf

# build rpaf from github source
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y build-essential apache2-threaded-dev unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/local/opt/rpaf 
ADD https://github.com/gnif/mod_rpaf/archive/stable.zip /usr/local/opt/rpaf
RUN cd /usr/local/opt/rpaf && unzip stable.zip
RUN cd /usr/local/opt/rpaf/mod_rpaf-stable && make && make install
ADD src/rpaf.load /etc/apache2/mods-available
ADD src/rpaf.conf /etc/apache2/mods-available

RUN apt-get remove -y --purge build-essential apache2-threaded-dev unzip

ADD src/startApache.sh /usr/local/bin
RUN chmod +x /usr/local/bin/startApache.sh

CMD ["/usr/local/bin/startApache.sh"]

