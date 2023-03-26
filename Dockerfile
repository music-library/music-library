# build environment
FROM golang:1.18.3-alpine as buildApi
COPY /api /app/server
WORKDIR /app/server
RUN apk update && apk add build-base
RUN go install -mod vendor github.com/go-task/task/v3/cmd/task
RUN go generate -tags tools tools/tools.go
RUN task bootstrap
RUN task builddocker

FROM node:16.19.1-alpine3.16 as buildClient
ENV PATH /app/node_modules/.bin:$PATH
COPY /client /app/client
WORKDIR /app
RUN cd /app/client && yarn install

# publish environment
FROM nginx:stable-alpine

RUN apk update && apk add git nodejs=16.19.1-r0 npm mediainfo vips
RUN npm install -g yarn && npm install -g pm2

COPY --from=buildApi /app/server/bin /app/server
COPY --from=buildClient /app/client /app/client
WORKDIR /app

VOLUME ["/app/data"]
VOLUME ["/app/music"]
VOLUME ["/app/music2"]
VOLUME ["/app/music3"]
VOLUME ["/app/music4"]
VOLUME ["/app/music5"]

ENV DATA_DIR "../data"
ENV MUSIC_DIR "../music"
ENV MUSIC_DIR2 "../music2"
ENV MUSIC_DIR3 "../music3"
ENV MUSIC_DIR4 "../music4"
ENV MUSIC_DIR5 "../music5"

ENV PORT 8000
ENV HOST 0.0.0.0

EXPOSE 80
EXPOSE 8000

COPY ./dockerbuild/nginx-default.conf /etc/nginx/conf.d/default.conf
COPY ./dockerbuild/docker-entrypoint.sh /app/docker-entrypoint.sh

CMD ["sh", "docker-entrypoint.sh"]
