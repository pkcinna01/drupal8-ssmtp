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
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/*

RUN { \
    echo '# docker xmonit/drupal8-with-ssmtp requires valid entries in /etc/ssmtp and sendmail path'; \
    echo 'sendmail_path = "/usr/sbin/sendmail -t -i"'; \
} >> /usr/local/etc/php/php.ini

