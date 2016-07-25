# docker-graphite-api-blueflood-finder

Builds a docker image with [custom Graphite-API](https://github.com/rackerlabs/graphite-api/tree/george/fetch_multi_with_patches) and [Blueflood Finder](https://github.com/rackerlabs/blueflood-graphite-finder). This means you can talk to an external blueflood 
instance through graphite-api service.

# Run graphite-api service with blueflood as datasource

```sh
docker run -d -p 8888:8888 -e GRAFANA_URLS=http://localhost:3000,http://192.168.1.200:3000 -e BLUEFLOOD_QUERY_URL=http://localhost:20000 -e TENANT_ID=123 rackerlabs/graphite-api
```

Here's the list of ENV variables and their description.

| Variable             |   Description                                       |  Default   |
| ---------------------|-----------------------------------------------------|------------|
| GRAFANA_URLS         | To allow [cross-domain requests(CORS) to graphite-api](https://github.com/brutasse/graphite-api/blob/master/docs/configuration.rst), provide comma separated urls which require cross-domain access | http://localhost:3000 |
| BLUEFLOOD_QUERY_URL  | Blueflood query endpoint | http://localhost:20000 |
| TENANT_ID            | Tenantid for which you are setting up graphite-api service | 123 |

Ports in the above command.

| Port             |   Description                                                  |
| -----------------|----------------------------------------------------------------|
| 8888             | graphite-api runs as a service and is available on this port.  |


# Run graphite-api service with rackspace metrics as datasource

```sh
docker run -d -p 8888:8888 -e GRAFANA_URLS=http://localhost:3000,http://192.168.1.200:3000 -e BLUEFLOOD_QUERY_URL=https://global.metrics.api.rackspacecloud.com -e TENANT_ID=123 -e RAX_USERNAME=bftest123 -e RAX_APIKEY=yoda123as rackerlabs/graphite-api
```

Here's the list of ENV variables and their description.

| Variable             |   Description                                       |  Default   |
| ---------------------|-----------------------------------------------------|------------|
| GRAFANA_URLS         | To allow [cross-domain requests(CORS) to graphite-api](https://github.com/brutasse/graphite-api/blob/master/docs/configuration.rst), provide comma separated urls which require cross-domain access | http://localhost:3000 |
| BLUEFLOOD_QUERY_URL  | Blueflood query endpoint | http://localhost:20000 |
| TENANT_ID            | Tenantid for which you are setting up graphite-api service | 123 |
| RAX_USERNAME         | Rackspace user name | 	-NA- |
| RAX_APIKEY           | Rackspace API key |	-NA- |

Ports in the above command.

| Port             |   Description                                               |
| -----------------|-------------------------------------------------------------|
| 8888             | graphite-api runs as a service and is available on this port.

# Sample requests

Here is a sample request to graphite-api service for finding and listing metrics available in the system.

```sh
curl -i -XGET 'http://localhost:8888/metrics/find?query=*'
```

# References

* Custom graphite-api: [https://github.com/rackerlabs/graphite-api/tree/george/fetch_multi_with_patches](https://github.com/rackerlabs/graphite-api/tree/george/fetch_multi_with_patches)
* blueflood finder: [https://github.com/rackerlabs/blueflood-graphite-finder](https://github.com/rackerlabs/blueflood-graphite-finder) 