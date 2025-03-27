# Tinyproxy Server

A forward proxy server setup using Tinyproxy to allow backend applications to make outbound requests through a consistent, static IP address.

## Components

- **Tinyproxy**: Lightweight HTTP/HTTPS proxy daemon with authentication

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
TIMEZONE=UTC            # Server timezone

# Access control settings
ALLOWED_CLIENTS=*       # IP addresses allowed to use the proxy

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

## Deployment on Coolify

1. **Add Repository**:
   - Connect your Git repository to Coolify
   - Select the repository containing this proxy server

2. **Configure Build**:
   - Choose Docker Compose as the deployment method
   - Leave the build command empty as we're using Docker Compose
   - Set port mapping: `8888:8888` for the proxy

3. **Environment Variables**:
   - Add all variables from the `.env` file
   - Make sure to set a strong `PROXY_PASSWORD`

4. **Deploy**:
   - Deploy the application

## Testing the Proxy

After deployment, test the proxy with:

```bash
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
- **Connection refused**: Check your firewall settings and ensure ports are open
- **Authentication errors**: Verify the username and password are correctly formatted in the URL

## Security Considerations

- Change the default proxy password to a strong value
- Consider IP-based restrictions for additional security
- Keep Docker and all containers updated