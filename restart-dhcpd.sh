#!/bin/sh
# Initialize the lease file if it doesn't exist.
touch dhcpd.leases

# We are doing this because openresty, while running LUA, cannot read the environment variables.
source /root/openresty.env

# This is updated to take the config with predefined token
curl {$API}/public/iaas/dhcp-servers/configuration/{$SERVER_ID} \
  -H "Authorization: {$ACCESS_TOKEN}" \
  -o /etc/dhcp/dhcpd.conf

rm /etc/default/isc-dhcp-server

echo "INTERFACESv4=\"$INTERFACE\"" > /etc/default/isc-dhcp-server

pkill dhcpd

# Restart the dhcpd service
service isc-dhcp-server restart
