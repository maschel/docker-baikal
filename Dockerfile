FROM alpine:3.7
MAINTAINER Dmitry Prazdnichnov <dp@bambucha.org>

ENV VERSION  0.4.6
ENV CHECKSUM 946e8e4161f7ef84be42430b6e9d3bb7dd4bbbe241b409be208c14447d7aa7a6

ADD baikal.sh /usr/local/bin/baikal

RUN apk --no-cache add unzip openssl lighttpd php7-cgi php7-ctype php7-dom \
        php7-pdo_sqlite php7-pdo_mysql php7-xml php7-openssl php7-json \
        php7-xmlreader php7-xmlwriter php7-session php7-mbstring \
    && wget https://github.com/fruux/Baikal/releases/download/$VERSION/baikal-$VERSION.zip \
    && echo $CHECKSUM "" baikal*.zip | sha256sum -c - \
    && unzip baikal*.zip \
    && rm baikal*.zip \
    && chmod +x /usr/local/bin/baikal \
    && sed -ie "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/g" /etc/php7/php.ini \
    && apk del -rf --purge openssl unzip

ADD lighttpd.conf /etc/lighttpd/lighttpd.conf

VOLUME /baikal/Specific

EXPOSE 80

ENTRYPOINT ["baikal"]
