FROM php:5.4-apache

RUN apt-get update && apt-get install -y --force-yes --no-install-recommends \
    libcurl4-openssl-dev \
    libedit-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    zlib1g-dev \
    freetds-dev \
    freetds-bin \
    freetds-common \
    libdbd-freetds \
    libsybdb5 \
    libqt4-sql-tds \
    libqt5sql5-tds \
    libqxmlrpc-dev \
    libmcrypt-dev \
    libpng-dev \
    libmemcached-dev \
    unixodbc \
    unixodbc-dev \
    sendmail \
    exiftool libpng-dev libjpeg62-turbo-dev libpng-dev libxpm-dev libfreetype6-dev \
    && ln -s /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/libsybdb.so \
    && ln -s /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib/libsybdb.a \
    && apt-get clean \
    && rm -r /var/lib/apt/lists/* 

RUN docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr \
    && docker-php-ext-configure mssql

RUN docker-php-ext-configure gd --with-gd --with-jpeg-dir \
    --with-png-dir --with-zlib-dir --with-freetype-dir \
    --enable-gd-native-ttf

RUN pecl install memcached-2.2.0 \
    && docker-php-ext-enable memcached

RUN pecl install redis-2.2.8 \
    && docker-php-ext-enable redis

RUN docker-php-ext-configure exif \
    && docker-php-ext-install bcmath calendar gettext exif gd pdo pdo_mysql curl json mbstring mysqli pdo_dblib mcrypt zip mysql mssql pdo_odbc

RUN pecl install zendopcache-7.0.5
RUN docker-php-ext-enable opcache

RUN set +e; \
    docker-php-ext-install odbc; \
    set -e; \
    cd /usr/src/php/ext/odbc; \
    phpize; \
    sed -ri 's@^ *test +"\$PHP_.*" *= *"no" *&& *PHP_.*=yes *$@#&@g' configure; \
    ./configure --with-unixODBC=shared,/usr; \
    docker-php-ext-install odbc; 

RUN set -ex && \
    curl -fSL -o pdflib.tar.gz http://www.pdflib.com/binaries/PDFlib/803/PDFlib-8.0.3-Linux-x86_64-C-C++.tar.gz && \
    mkdir /usr/local/pdflib && \
    tar -xzf pdflib.tar.gz -C /usr/local/pdflib && \
    printf "/usr/local/pdflib/PDFlib-8.0.3-Linux-x86_64-C-C++/bind/c" | pecl install pdflib

# Install Ioncube Loader
RUN curl -L https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz -o ioncube.tar.gz \
    && tar -xvzf ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_5.4.so /usr/local/lib/php/extensions/no-debug-non-zts-20100525/ \
    && rm -rf ioncube.tar.gz ioncube \
    && echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20100525/ioncube_loader_lin_5.4.so" > /usr/local/etc/php/conf.d/docker-php-ext-ioncube.ini

COPY conf/php.ini /usr/local/etc/php/
COPY conf.d/ /usr/local/etc/php/conf.d/
COPY conf/httpd.conf /etc/apache2/sites-available/000-default.conf

RUN chmod 755 /var/www/html -R
COPY --chown=www-data:www-data public/ /var/www/html/

RUN a2enmod rewrite headers 

CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
