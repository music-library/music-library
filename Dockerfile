FROM nginx:latest

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update && apt-get install curl varnish -y

# NVM (Node + NPM)
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 14.18.2
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/v$NODE_VERSION/bin:$PATH

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
