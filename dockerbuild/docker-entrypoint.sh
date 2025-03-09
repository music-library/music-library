#!/bin/bash


## Inject environment variables with `reactenv`
## See https://github.com/hmerritt/reactenv
echo -e "\n\n* Inject environment variables"

reactenv run /usr/share/nginx/html/assets

if [ "${?}" != "0" ]; then
    exit 1
fi


##  Start server
echo -e "\n\n* Starting server"
rc-status
rc-service musicapi start
rc-service musicapi status


##  Start serving app
echo -e "\n\n* Start serving app"
nginx -g "daemon off;"
