FROM nginx:1.16.0-alpine

RUN apk update
RUN apk add nodejs npm
RUN npm i -g pm2

COPY /backend /app/server
COPY /client /app/client
WORKDIR /app

VOLUME ["/app/music"]

ENV MUSIC_DIR "../music"
ENV PORT 8000

EXPOSE 80
EXPOSE 8000

COPY docker-entrypoint.sh /app/docker-entrypoint.sh
CMD ["sh", "docker-entrypoint.sh"]
