FROM alpine
MAINTAINER Rustam Tagaev <linuxoid69@gmail.com>

# Proxy settings if necessary
# ENV http_proxy=http://proxy:8080
# ENV https_proxy=http://proxy:8080
# ENV no_proxy="127.0.0.1,localhost,.mydomain.com"

# Install and configure Apache WebDAV and Subversion
RUN apk --no-cache add \
    apache2 \
    apache2-utils \
    php5-apache2 \
    apache2-webdav \
    mod_dav_svn \
    subversion \
    php5 \
    php5-pear \
    php5-sqlite3 \
    php5-mysql \
    php5-mysqli \
    && ln -s /usr/bin/php5 /usr/bin/php \
    && pear install channel://pear.php.net/VersionControl_SVN-0.5.2
# ADD https://vorboss.dl.sourceforge.net/project/svnmanager/svnmanager/1.10/svnmanager-1.10.tar.gz /tmp
COPY svnmanager-1.10.tar.gz /tmp
RUN mkdir -p /run/apache2 \
    && tar xfvz /tmp/svnmanager-1.10.tar.gz  -C /tmp \
    && mv /tmp/svnmanager-1.10/* /var/www/localhost/htdocs/ \
    && rm /tmp/svnmanager-1.10.tar.gz /var/www/localhost/htdocs/index.html 

COPY rootfs /

RUN chmod +x /run.sh

EXPOSE 80

# Define default command
CMD ["/run.sh"]
