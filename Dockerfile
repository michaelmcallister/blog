FROM klakegg/hugo:0.83.1-onbuild AS build
COPY . .

FROM nginx:1.21-alpine
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=build /target /usr/share/nginx/html
EXPOSE 80