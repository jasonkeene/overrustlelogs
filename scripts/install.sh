#!/bin/bash

export src="github.com/slugalisk/overrustlelogs"
source /etc/profile

mkdir -p $GOPATH/src/github.com/slugalisk
ln -s $(readlink -e $(dirname $0)/..) $GOPATH/src/$src

go install $src/logger
go install $src/server
go install $src/bot
go install $src/tool

cp $GOPATH/bin/logger /usr/bin/orl-logger
cp $GOPATH/bin/server /usr/bin/orl-server
cp $GOPATH/bin/server /usr/bin/orl-bot
cp $GOPATH/bin/tool /usr/bin/orl-tool

mkdir -p /var/overrustlelogs/public
cp -r $GOPATH/src/$src/server/views /var/overrustlelogs/views
cp -r $GOPATH/src/$src/server/assets /var/overrustlelogs/public/assets
chown -R overrustlelogs:overrustlelogs /var/overrustlelogs/views
chown -R overrustlelogs:overrustlelogs /var/overrustlelogs/public/assets
cp -r $GOPATH/src/$src/package/* /
if [ -f "$GOPATH/src/$src/package/etc/overrustlelogs/overrustlelogs.local.conf" ]; then
	cp -p "$GOPATH/src/$src/package/etc/overrustlelogs/overrustlelogs.local.conf" /etc/overrustlelogs/overrustlelogs.conf
fi
chown -R overrustlelogs:overrustlelogs /var/overrustlelogs

mkdir -p /var/nginx/cache
chown -R www-data:www-data /var/nginx

## systemd support
if [ -z `which start` ]; then
	SSS="systemctl "
else
	SSS=""
fi

echo "next steps:"
echo "1.) add creds to /etc/overrustlelogs/overrustlelogs.conf"
echo "2.) run $ ${SSS}start logger && ${SSS}start server"