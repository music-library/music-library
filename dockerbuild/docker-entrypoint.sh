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
cat << EOF > /etc/init.d/musicapi
#!/sbin/openrc-run

export HOST="$HOST"
export PORT="$PORT"
export LogFile="$LogFile"
export LogLevel="$LogLevel"
export AuthPassword="$AuthPassword"
export ReIndexEvery="$ReIndexEvery"
export DATA_DIR="$DATA_DIR"
export MUSIC_DIR="$MUSIC_DIR"
export MUSIC_DIR_NAME="$MUSIC_DIR_NAME"
export MUSIC_DIR2="$MUSIC_DIR2"
export MUSIC_DIR2_NAME="$MUSIC_DIR2_NAME"
export MUSIC_DIR3="$MUSIC_DIR3"
export MUSIC_DIR3_NAME="$MUSIC_DIR3_NAME"
export MUSIC_DIR4="$MUSIC_DIR4"
export MUSIC_DIR4_NAME="$MUSIC_DIR4_NAME"
export MUSIC_DIR5="$MUSIC_DIR5"
export MUSIC_DIR5_NAME="$MUSIC_DIR5_NAME"

name="music-api"
command_background="yes"
command="/app/server/music-api"
directory="/app/server"
pidfile="/var/run/music-api.pid"
output_log="/app/music.log"
error_log="/app/music.err"
EOF
mkdir /run/openrc
touch /run/openrc/softlevel
chmod +x /app/server/music-api
chmod +x /etc/init.d/musicapi
rc-update add musicapi default
rc-status
rc-service musicapi start
rc-service musicapi status


##  Start serving app
echo -e "\n\n* Start serving app"
nginx -g "daemon off;"
