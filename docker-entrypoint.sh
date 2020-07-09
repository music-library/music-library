#!/bin/ash


## Install required programs
apk update && apk add nodejs npm python2 build-base && npm i -g pm2


## Setup server
echo -e "\n\n* Setup app server"
cd /app/server
npm install --only=prod


##  Build client app
echo -e "\n\n* Build app client"
cd /app/client
npm install --only=prod
npm run build

## Move built app to www
cd /app
mv -v /app/client/build/* /usr/share/nginx/html
rm -rf /app/client
ln -s /usr/share/nginx/html /app/client


##  Start server
echo -e "\n\n* Starting server"
cd /app/server
pm2 start bin/index.js


##  Start serving app
echo -e "\n\n* Start serving app"
nginx -g 'daemon off;'
