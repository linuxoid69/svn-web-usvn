#!/bin/sh
set +x 
SVNMANAGER_CONFIG='/var/www/localhost/htdocs/config.php'
SMTP_SERVER=${SMTP_SERVER:=localhost}
DB_TYPE=${DB_TYPE:='mysql'}
DB_NAME=${DB_NAME:=svnmanager}
DB_HOST=${DB_HOST:=localhost}
HTTPD_CONF=${HTTPD_CONF:=/etc/apache2/httpd.conf}


if [[ ${DB_TYPE} == 'mysql' ]] ;then
    
    sed -i -r "s#SVNMANAGER_USER_DB#${SVNMANAGER_USER_DB}#"  ${SVNMANAGER_CONFIG}
    
    sed -i -r "s#SVNMANAGER_PASSWD_DB#${SVNMANAGER_PASSWD_DB}#"  ${SVNMANAGER_CONFIG}
    
    sed -i -r "s#DB_NAME#${DB_NAME}#"  ${SVNMANAGER_CONFIG}
    
    sed -i -r "s#DB_HOST#${DB_HOST}#"  ${SVNMANAGER_CONFIG}
    
    sed -i -r "s#SMTP_SERVER#${SMTP_SERVER}#"  ${SVNMANAGER_CONFIG}
fi

sed -i -r 's#.*(DirectoryIndex).*#\1 index.php#' ${HTTPD_CONF}

if [ -n "$SVN_REPO" ]; then
test ! -d "/var/svn/$SVN_REPO" && svnadmin create /var/svn/$SVN_REPO \
                               && chgrp -R apache /var/svn/$SVN_REPO \
                               && chmod -R 775 /var/svn/$SVN_REPO
    echo "Creating the repository: $SVN_REPO into /var/svn/"
else
    test ! -d "/var/svn/testrepo" \
                               && svnadmin create /var/svn/testrepo \
                               && chgrp -R apache /var/svn/testrepo \
                               && chmod -R 775 /var/svn/testrepo
    echo "Warning: SVN_REPO variable not defined, starting with svn default repository: testrepo into /var/svn/"
fi

httpd -D FOREGROUND
