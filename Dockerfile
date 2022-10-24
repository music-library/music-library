# build environment
FROM node:14 as build
ENV PATH /app/node_modules/.bin:$PATH
COPY /backend /app/server
COPY /client /app/client
WORKDIR /app
RUN cd /app/server && npm install --only=prod
RUN cd /app/client && yarn install

# publish environment
FROM nginx:latest

RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update && apt-get install git nodejs -y

RUN npm install -g yarn && npm install -g pm2

COPY --from=build /app/server /app/server
COPY --from=build /app/client /app/client
WORKDIR /app

VOLUME ["/app/music"]
VOLUME ["/app/data"]

ENV MUSIC_DIR "../music"
ENV DATA_DIR "../data"
ENV PORT 8000

EXPOSE 80
EXPOSE 8000

COPY ./dockerbuild/nginx-default.conf /etc/nginx/conf.d/default.conf
COPY ./dockerbuild/docker-entrypoint.sh /app/docker-entrypoint.sh

CMD ["sh", "docker-entrypoint.sh"]
