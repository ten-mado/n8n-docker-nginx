#!/bin/sh

if [ -d /root/.n8n ] ; then
  chmod o+rx /root
  chown -R node /root/.n8n
  ln -s /root/.n8n /home/node/
fi
cp -R /additional_modules/node_modules /node_modules

exec su-exec node n8n