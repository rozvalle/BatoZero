#!/bin/sh

echo "Stopping ZeroTier daemon..."
pkill zerotier-one

echo "Removing TUN devices..."
ip link show tun0 >/dev/null 2>&1 && ip link delete tun0

echo "Removing binaries from /usr/bin..."
rm -f /usr/bin/zerotier-one /usr/bin/zerotier-cli /usr/bin/zerotier-idtool

echo "Removing startup service..."
rm -f /userdata/system/services/Zerotier

echo "Cleaning up temporary folders..."
rm -rf ./bin
rm -f zerotier-one-*.tar.gz

echo "ZeroTier has been uninstalled."
