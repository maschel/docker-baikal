FROM alpine:3.7
MAINTAINER Dmitry Prazdnichnov <dp@bambucha.org>

ENV VERSION  0.4.6
ENV CHECKSUM 946e8e4161f7ef84be42430b6e9d3bb7dd4bbbe241b409be208c14447d7aa7a6

ADD baikal.sh /usr/local/bin/baikal

# Add CODECASTS php-alpine public key
ADD https://php.codecasts.rocks/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub

# make sure we can use HTTPS
RUN apk --update add ca-certificates

# Add CODECAST PHP7 Repository
RUN echo "@php https://php.codecasts.rocks/v3.7/php-7.2" >> /etc/apk/repositories

RUN apk --no-cache add unzip openssl lighttpd php7-cgi@php php7-ctype@php php7-dom@php \
        php7-pdo_sqlite@php php7-pdo_mysql@php php7-xml@php php7-openssl@php php7-json@php \
        php7-xmlreader@php \
    && wget https://github.com/fruux/Baikal/releases/download/$VERSION/baikal-$VERSION.zip \
    && echo $CHECKSUM "" baikal*.zip | sha256sum -c - \
    && unzip baikal*.zip \
    && rm baikal*.zip \
    && chmod +x /usr/local/bin/baikal \
    && sed -ie "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/php.ini \
    && mkdir /baikal/html/.well-known \
    && apk del -rf --purge openssl unzip

ADD lighttpd.conf /etc/lighttpd/lighttpd.conf

VOLUME /baikal/Specific

EXPOSE 80

ENTRYPOINT ["baikal"]
