FROM php:7.4-apache

EXPOSE 80/tcp

COPY conf/ /etc/apache2

RUN a2enmod proxy proxy_http
RUN a2ensite 000-* 001-*