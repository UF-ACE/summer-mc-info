FROM node:erbium as builder

WORKDIR /app

ADD package.json . 
ADD yarn.lock . 
RUN yarn install

ADD . .

RUN yarn build

FROM node:erbium as prod-mods
ENV NODE_ENV production
WORKDIR /app

ADD package.json . 
ADD yarn.lock . 
RUN yarn install

FROM nginx:1.18-alpine

COPY --from=builder /app/assets /usr/share/nginx/html/assets/
COPY --from=builder /app/index.html /usr/share/nginx/html/
COPY --from=builder /app/main.min.css /usr/share/nginx/html/
COPY --from=prod-mods /app/ /usr/share/nginx/html/
ADD nginx.conf /etc/nginx/nginx.conf
