FROM alpine
LABEL  maintainer="Rustam Tagaev <linuxoid69@gmail.com>"

ADD https://github.com/usvn/usvn/archive/1.0.10.tar.gz /tmp
# Install and configure Apache WebDAV and Subversion
RUN apk --no-cache add ca-certificates wget && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r0/glibc-2.35-r0.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r0/glibc-bin-2.35-r0.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r0/glibc-i18n-2.35-r0.apk && \
    apk --no-cache add \
    glibc-bin-2.35-r0.apk\
    glibc-i18n-2.35-r0.apk\
    glibc-2.35-r0.apk \
    icu-libs \
    php5-intl \
    icu-libs \
    apache2 \
    apache2-utils \
    php5-apache2 \
    apache2-webdav \
    mod_dav_svn \
    subversion \
    php5 \
    php5-mysql \
    php5-mysqli \
    php5-ctype \
    php5-pdo_mysql \
    php5-pdo_sqlite \
    php5-iconv \
    && mkdir -p /run/apache2 \
    && tar xfvz /tmp/1.0.10.tar.gz  -C /tmp \
    && mv /tmp/usvn-1.0.10/* /var/www/localhost/htdocs/ \
    && chown -R apache /var/www/localhost/htdocs/public \
    && chown -R apache /var/www/localhost/htdocs/config \
    && rm -fr /tmp/*

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_CTYPE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

COPY rootfs /

RUN cat locale.md | xargs -i /usr/glibc-compat/bin/localedef -i {} -f UTF-8 {}.UTF-8 \
    && ln -s /usr/glibc-compat/bin/locale /bin/locale \
    && chmod +x /run.sh \
    && chown apache:apache -R /var/svn/ \
    && rm /glibc* locale.md

EXPOSE 80

# Define default command
CMD ["/run.sh"]
