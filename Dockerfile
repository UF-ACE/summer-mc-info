FROM node:erbium as builder

WORKDIR /app

ADD package.json . 
ADD yarn.lock . 
RUN yarn install

ADD . .

RUN yarn build:css
RUN yarn build:html

FROM nginx:1.18-alpine

COPY --from=builder /app/assets /usr/share/nginx/html/assets/
COPY --from=builder /app/index.min.html /usr/share/nginx/html/index.html
COPY --from=builder /app/main.min.css /usr/share/nginx/html/
ADD nginx.conf /etc/nginx/nginx.conf
