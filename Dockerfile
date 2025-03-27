FROM vimagick/tinyproxy:latest

# Create a copy of the original config file
RUN cp /etc/tinyproxy/tinyproxy.conf /etc/tinyproxy/tinyproxy.conf.orig

# Create log directory with proper permissions
RUN mkdir -p /var/log/tinyproxy && chmod 777 /var/log/tinyproxy

# Create an entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]