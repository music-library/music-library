FROM nginx:latest

RUN apt-get update && apt-get install varnish nodejs npm -y
RUN npm install pm2 -g

COPY /backend /app/server
COPY /client /app/client
WORKDIR /app

RUN cd /app/server && npm install --only=prod
RUN cd /app/client && npm install --only=prod

VOLUME ["/app/music"]
VOLUME ["/app/data"]

ENV MUSIC_DIR "../music"
ENV DATA_DIR "../data"
ENV VARNISH_SIZE 1000M
ENV PORT 8000

EXPOSE 80
EXPOSE 8000

COPY ./dockerbuild/nginx-default.conf /etc/nginx/conf.d/default.conf
COPY ./dockerbuild/varnish-default.vcl /etc/varnish/default.vcl
COPY ./dockerbuild/varnish /etc/default/varnish

COPY ./dockerbuild/docker-entrypoint.sh /app/docker-entrypoint.sh
CMD ["sh", "docker-entrypoint.sh"]
