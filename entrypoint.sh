#!/bin/sh

# Reset config to original version
cp /etc/tinyproxy/tinyproxy.conf.orig /etc/tinyproxy/tinyproxy.conf

# Add BasicAuth if credentials are provided
if [ -n "$PROXY_USER" ] && [ -n "$PROXY_PASSWORD" ]; then
  echo "Adding BasicAuth to tinyproxy.conf..."
  echo "" >> /etc/tinyproxy/tinyproxy.conf
  echo "# Added by entrypoint script" >> /etc/tinyproxy/tinyproxy.conf
  echo "BasicAuth $PROXY_USER $PROXY_PASSWORD" >> /etc/tinyproxy/tinyproxy.conf
  echo "BasicAuth added for user $PROXY_USER"
fi

# Start tinyproxy in foreground
exec tinyproxy -d