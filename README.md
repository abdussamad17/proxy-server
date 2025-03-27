# Tinyproxy Server

A forward proxy server setup using Tinyproxy to allow backend applications to make outbound requests through a consistent, static IP address.

## Components

- **Tinyproxy**: Lightweight HTTP/HTTPS proxy daemon with authentication
- **Admin Dashboard**: Web interface to monitor proxy stats and status
- **~~Prometheus Exporter~~**: (Optional) Metrics exporter for monitoring

## Prerequisites

- Docker and Docker Compose
- A server with a static IP address (for production)
- Coolify instance for deployment

## Configuration

### Environment Variables

Edit the `.env` file to configure your proxy settings:

```
# Tinyproxy configuration
PROXY_PORT=8888         # Port for the proxy server
ADMIN_PORT=8080         # Port for the admin dashboard
METRICS_PORT=9240       # Port for metrics (if metrics exporter is enabled)
TIMEZONE=UTC            # Server timezone

# Access control settings
ALLOWED_CLIENTS=*       # IP addresses allowed to use the proxy
ADMIN_USER=admin        # Admin username
ADMIN_PASSWORD=change_me_please  # Admin password (change this!)

# Proxy authentication
PROXY_USER=proxyuser    # Username for proxy authentication
PROXY_PASSWORD=changeThisPassword!  # Password for proxy authentication (change this!)

# Proxy settings
ENABLE_FILTER=true      # Enable content filtering
MAX_CLIENTS=100         # Maximum number of clients
MIN_SPARE_SERVERS=5     # Minimum idle servers
MAX_SPARE_SERVERS=20    # Maximum idle servers
START_SERVERS=10        # Initial server count
MAX_REQUESTS_PER_CHILD=0  # Maximum requests before recycling
```

### Proxy Authentication

The proxy server is configured with HTTP Basic Authentication. You need to provide username and password in the format:

```
http://username:password@proxy-host:proxy-port
```

For example:
```
http://proxyuser:changeThisPassword!@your-server-ip:8888
```

### Tinyproxy Configuration

The main configuration file is in `config/tinyproxy.conf`. Some important settings:

- **Access control**: Configure allowed IP ranges in the `Allow` directives
- **Authentication**: Uncomment `BasicAuth` lines if you want password protection
- **Filtering**: Enable content filtering with the `Filter` directive
- **Logging**: Configure log level and location

## Deployment on Coolify

1. **Add Repository**:
   - Connect your Git repository to Coolify
   - Select the repository containing this proxy server

2. **Configure Build**:
   - Choose Docker Compose as the deployment method
   - Leave the build command empty as we're using Docker Compose
   - Set port mappings:
     - `8888:8888` for the proxy
     - `8080:80` for the admin interface

3. **Environment Variables**:
   - Add all variables from the `.env` file
   - Make sure to set a strong `PROXY_PASSWORD`

4. **Deploy**:
   - Deploy the application

5. **Important Configuration Notes**:
   - If the proxy fails to start, check the PidFile path in tinyproxy.conf
   - Make sure it's set to a writable location: `PidFile "/tmp/tinyproxy.pid"`

## Testing the Proxy

After deployment, test the proxy with:

```bash
# Test the admin interface
curl -I http://your-server-ip:8080

# Test the proxy without authentication (should work for IP-based ACL)
curl -x http://your-server-ip:8888 https://example.com

# Test the proxy with authentication
curl -x http://proxyuser:changeThisPassword!@your-server-ip:8888 https://example.com
```

## Using with Backend Applications

### Node.js Example

```javascript
// Using Axios with a proxy
const axios = require('axios');

const proxyConfig = {
  proxy: {
    host: 'your-proxy-ip',
    port: 8888,
    auth: {
      username: 'proxyuser',
      password: 'changeThisPassword!'
    }
  }
};

// Make requests through the proxy
axios.get('https://api.example.com', proxyConfig)
  .then(response => console.log(response.data));
```

### Environment Variables Example

```bash
# For applications that use environment variables
HTTP_PROXY=http://proxyuser:changeThisPassword!@your-proxy-ip:8888
HTTPS_PROXY=http://proxyuser:changeThisPassword!@your-proxy-ip:8888
```

## Troubleshooting

- **Proxy not starting**: Check docker logs for errors
- **Admin interface shows "Proxy not responding"**: Check if the tinyproxy container is running
- **Connection refused**: Check your firewall settings and ensure ports are open
- **Authentication errors**: Verify the username and password are correctly formatted in the URL

## Security Considerations

- Change the default proxy password to a strong value
- Consider IP-based restrictions for additional security
- Keep Docker and all containers updated