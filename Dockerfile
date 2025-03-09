# Build environment
FROM golang:1.18.3-alpine as buildApi
COPY /api /app/server
WORKDIR /app/server
RUN apk update && apk add build-base git
RUN go install -mod vendor github.com/go-task/task/v3/cmd/task
RUN go generate -tags tools tools/tools.go
RUN task bootstrap
RUN task builddocker

FROM node:18-alpine as buildClient
ENV PATH /app/node_modules/.bin:$PATH
COPY /client /app/client
WORKDIR /app/client
RUN apk update && apk add git
# Set every React env value here
ENV REACT_APP_HTTP __reactenv.REACT_APP_HTTP
ENV REACT_APP_HOST __reactenv.REACT_APP_HOST
ENV REACT_APP_API __reactenv.REACT_APP_API
RUN yarn install
RUN yarn build

# Publish environment
FROM nginx:stable-alpine

RUN apk update && apk add --no-cache bash curl git libc6-compat mediainfo openrc vips vips-tools
RUN curl -s https://releases.mrrtt.me/reactenv/get.sh | bash -s /usr/local/bin

COPY --from=buildApi /app/server/bin /app/server
COPY --from=buildClient /app/client/dist /usr/share/nginx/html

COPY ./dockerbuild/nginx-default.conf /etc/nginx/conf.d/default.conf
COPY ./dockerbuild/openrc_music-api /etc/init.d/musicapi
COPY ./dockerbuild/docker-entrypoint.sh /app/docker-entrypoint.sh

RUN chmod +x /app/server/music-api && chmod +x /etc/init.d/musicapi && rc-update add musicapi default
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

CMD ["sh", "docker-entrypoint.sh"]
