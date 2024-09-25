#!/bin/sh
# Initialize the lease file if it doesn't exist.
touch dhcpd.leases

# We are doing this because openresty, while running LUA, cannot read the environment variables.
source openresty.env

curl {$API}/iaas/configurations/dhcp-servers/{$SERVER_ID} \
  -H "Authorization: Bearer {$ACCESS_TOKEN}" \
  -o dhcpd.conf

rm /etc/default/isc-dhcp-server

echo "INTERFACESv4=\"$INTERFACE\"" > /etc/default/isc-dhcp-server

pkill dhcpd

# Restart the dhcpd service
dhcpd -cf dhcpd.conf -lf dhcpd.leases --no-pid -4 -f