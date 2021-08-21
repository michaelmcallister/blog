FROM klakegg/hugo:onbuild AS build
COPY . .

FROM nginx:1.21-alpine
COPY nginx /etc/nginx 
COPY --from=build /target /var/www/blog.skunkw0rks.io/public/ 
RUN adduser -u 82 -D -S -G www-data www-data
EXPOSE 80
