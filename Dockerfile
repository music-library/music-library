FROM nginx:1.16.0-alpine

COPY /backend /app/server
COPY /client /app/client
WORKDIR /app

VOLUME ["/app/music"]
VOLUME ["/app/data"]

ENV MUSIC_DIR "../music"
ENV DATA_DIR "../data"
ENV PORT 8000

EXPOSE 80
EXPOSE 8000

COPY default.conf /etc/nginx/conf.d/default.conf
COPY docker-entrypoint.sh /app/docker-entrypoint.sh
CMD ["sh", "docker-entrypoint.sh"]
