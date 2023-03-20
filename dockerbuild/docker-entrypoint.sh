#!/bin/bash


echo -e "\n\n* Build app client"
cd /app/client
yarn build

## Move built app to www
cd /app
mv -v /app/client/dist/* /usr/share/nginx/html
rm -rf /app/client
ln -s /usr/share/nginx/html /app/client


##  Start server
echo -e "\n\n* Starting server"
cd /app/server
pm2 start ./music-api --name music-api


##  Start serving app
echo -e "\n\n* Start serving app"
nginx -g "daemon off;"
