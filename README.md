# docker-graphite-api-blueflood-finder

Builds a [docker image](https://hub.docker.com/r/rackerlabs/graphite-api-blueflood-finder/) with [custom Graphite-API](https://github.com/rackerlabs/graphite-api/tree/1.1.3-rax.1) and [Blueflood Finder](https://github.com/rackerlabs/blueflood-graphite-finder). This means you can talk to an external blueflood 
instance through graphite-api service.

# Prerequisites

1. install docker:  https://docs.docker.com/

2. clone this repo
```sh
git clone https://github.com/rackerlabs/docker-graphite-api-blueflood-finder.git
cd docker-graphite-api-blueflood-finder/
```

# Create environment variables file

Environment variables file is recommended especially in the case you need to specify API key.

## Create environment variables file  with blueflood as datasource

```
GRAFANA_URLS=http://localhost:3000,http://192.168.1.200:3000
BLUEFLOOD_QUERY_URL=http://localhost:20000
TENANT_ID=123
```

Here's the list of ENV variables and their description.

| Variable             |   Description                                       |  Default   |
| ---------------------|-----------------------------------------------------|------------|
| GRAFANA_URLS         | To allow [cross-domain requests(CORS) to graphite-api](https://github.com/brutasse/graphite-api/blob/master/docs/configuration.rst), provide comma separated urls which require cross-domain access | http://localhost:3000 |
| BLUEFLOOD_QUERY_URL  | Blueflood query endpoint | http://localhost:20000 |
| TENANT_ID            | Tenant id for which you are setting up graphite-api service | 123 |



## Create environment File with Rackspace Metrics as datasource
```
GRAFANA_URLS=http://localhost:3000,http://192.168.1.200:3000
BLUEFLOOD_QUERY_URL=https://global.metrics.api.rackspacecloud.com
TENANT_ID=[rackspace account tenant ID]
RAX_USERNAME=[rackspace user name]
RAX_APIKEY=[rackspace user api key]
```

Here's the list of ENV variables and their description.

| Variable             |   Description                                       |  Default   |
| ---------------------|-----------------------------------------------------|------------|
| GRAFANA_URLS         | To allow [cross-domain requests(CORS) to graphite-api](https://github.com/brutasse/graphite-api/blob/master/docs/configuration.rst), provide comma separated urls which require cross-domain access | http://localhost:3000 |
| BLUEFLOOD_QUERY_URL  | Blueflood query endpoint | http://localhost:20000 |
| TENANT_ID            | Tenant id for which you are setting up graphite-api service | 123 |
| RAX_USERNAME         | Rackspace user name | 	-NA- |
| RAX_APIKEY           | Rackspace API key |	-NA- |

# Run graphite-api service with environment file

```sh
# In the same directory with Dockerfile.
# If run it anywhere else, the command is use the official docker image instead
# https://hub.docker.com/r/rackerlabs/graphite-api-blueflood-finder/
docker run -d -p 9999:8888 --env-file graphite.env rackerlabs/graphite-api-blueflood-finder
```

Ports in the above command.

| Port             |   Description                                                  |
| -----------------|----------------------------------------------------------------|
| 9999             | graphite-api runs as a service and is available on this port.  |

# Sample requests

Here is a sample request to graphite-api service for finding and listing metrics available in the system.

```sh
curl -i -XGET 'http://localhost:9999/metrics/find?query=*'
```

# Build and Push Docker to hub.docker.com
```sh
docker build -t rackerlabs/graphite-api-blueflood-finder .

# you will need a login on hub.docker.com with access to the rackerlabs organization
docker login
docker push rackerlabs/graphite-api-blueflood-finder
```

# List, Connect, Stop, and Remove Docker containers
```sh
docker ps
docker ps -a
docker exec -t -i <container_id> /bin/bash
docker stop <container_id>
docker rm <container_id>
```

# References

* Custom graphite-api: [https://github.com/rackerlabs/graphite-api/tree/1.1.3-rax.1](https://github.com/rackerlabs/graphite-api/tree/1.1.3-rax.1)
* blueflood finder: [https://github.com/rackerlabs/blueflood-graphite-finder](https://github.com/rackerlabs/blueflood-graphite-finder) 
