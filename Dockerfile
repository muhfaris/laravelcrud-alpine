FROM ej52/alpine-nginx-php:7.1.5
MAINTAINER Muh Faris <muhfaris@disroot.org>

RUN apk update \
&& apk add git
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

RUN adduser -D -S userbaru
USER userbaru
RUN cd /home/userbaru \
&& git clone https://github.com/muhfaris/laravel-crud-demo.git \
&& mv laravel-crud-demo laravel \
&& cd laravel \
&& composer install \
&& php artisan migrate --seed

USER root
RUN mv /home/userbaru/laravel /var/www/ \
&& chown -R www-data.www-data /var/www/laravel \
&& chmod -R 775 /var/www/laravel/storage \
&& chmod -R 775 /var/www/laravel/bootstrap/cache

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
&& ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443
