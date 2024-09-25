#!/bin/sh
rm openresty.env -f

# We are creating a source file because OpenResty cannot use environment variables
echo "INTERFACE=$INTERFACE" >> openresty.env
echo "API=$API" >> openresty.env
echo "SERVER_ID=$SERVER_ID" >> openresty.env
echo "ACCESS_TOKEN=$ACCESS_TOKEN" >> openresty.env

openresty -g "daemon off;" -c /etc/openresty/nginx.conf