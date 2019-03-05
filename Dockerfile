FROM node:alpine AS builder

LABEL maintainer="Mohammed Essehemy <mohammedessehemy@gmail.com>"

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install && npm audit fix

COPY ./ ./

RUN npm run build



FROM nginxinc/nginx-unprivileged:stable-alpine

LABEL maintainer="Mohammed Essehemy <mohammedessehemy@gmail.com>"

EXPOSE 8080

USER root

RUN echo 'server { \
    listen       8080; \
    server_name  ـ; \
    gzip on; \
    gzip_types    text/plain application/javascript application/x-javascript text/javascript text/xml text/css; \
    location / { \
    root   /usr/share/nginx/html; \
    index  index.html index.htm; \
    try_files $uri $uri/ /index.html; \
    } \
    # redirect server error pages to the static page /50x.html \
    error_page   500 502 503 504  /50x.html; \
    location = /50x.html { \
    root   /usr/share/nginx/html; \
    } \
    }' > /etc/nginx/conf.d/default.conf

COPY --chown=1001:1001 --from=builder /app/public /usr/share/nginx/html

USER 1001