FROM node:erbium as builder

WORKDIR /app
ENV NODE_ENV production

ADD package.json . 
ADD yarn.lock . 
RUN yarn install

ADD . .

FROM nginx:1.18-alpine

COPY --from=builder /app/ /usr/share/nginx/html/
