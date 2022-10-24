FROM nginx:latest

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get update && apt-get install varnish git nodejs -y

RUN npm install -g yarn && npm install -g pm2

COPY /backend /app/server
COPY /client /app/client
WORKDIR /app

RUN cd /app/server && npm install --only=prod
RUN cd /app/client && yarn install

VOLUME ["/app/music"]
VOLUME ["/app/data"]

ENV MUSIC_DIR "../music"
ENV DATA_DIR "../data"
ENV VARNISH_SIZE 1000M
ENV PORT 8000

EXPOSE 80
EXPOSE 8000

COPY ./dockerbuild/nginx-default.conf /etc/nginx/conf.d/default.conf
COPY ./dockerbuild/docker-entrypoint.sh /app/docker-entrypoint.sh

CMD ["sh", "docker-entrypoint.sh"]
