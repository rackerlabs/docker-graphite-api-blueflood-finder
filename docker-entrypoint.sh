#!/bin/bash -x

: ${BLUEFLOOD_QUERY_URL="http://localhost:20000"}
: ${TENANT_ID="123"}
: ${GRAFANA_URLS="http://localhost:3000"}

exec 2>&1
exec 1>/tmp/bash-debug.log
apt-get update -y --force-yes

if [[ -n "$BLUEFLOOD_PORT_20000_TCP_ADDR" ]] && [[ -n "$BLUEFLOOD_PORT_20000_TCP_PORT" ]]
then
export BLUEFLOOD_QUERY_URL="http://$BLUEFLOOD_PORT_20000_TCP_ADDR:$BLUEFLOOD_PORT_20000_TCP_PORT"
fi

cat > /etc/graphite-api.yaml << EOL
search_index: /dev/null
finders:
  - blueflood_graphite_finder.blueflood.TenantBluefloodFinder
functions:
  - graphite_api.functions.SeriesFunctions
  - graphite_api.functions.PieFunctions
time_zone: UTC
logging:
  version: 1
  handlers:
    blueflood_finder_loghandler:
      class: logging.handlers.RotatingFileHandler
      filename: /var/log/blueflood-graphite-finder.log
      formatter: default
      backupCount: 2
      maxBytes: 536870912
  loggers:
    blueflood_finder:
      handlers:
        - blueflood_finder_loghandler
      propagate: true
      level: INFO
  formatters:
    default:
      format: '%(asctime)s %(levelname)-8s %(name)-15s %(message)s'
      datefmt: '%Y-%m-%d %H:%M:%S'
blueflood:
  tenant: $TENANT_ID
  urls:
    - $BLUEFLOOD_QUERY_URL
EOL


if [[ -n "$RAX_USERNAME" ]] ||  [[ -n "$RAX_APIKEY" ]]
then
cat >> /etc/graphite-api.yaml << EOL
  username: $RAX_USERNAME             
  apikey: $RAX_APIKEY                     
  authentication_module: blueflood_graphite_finder.rax_auth
  authentication_class: BluefloodAuth
EOL
fi

echo "allowed_origins:" >> /etc/graphite-api.yaml

if [[ $GRAFANA_URLS == "*" ]]
then
  echo "  - *" >> /etc/graphite-api.yaml
else  
  origins=$(echo $GRAFANA_URLS | tr "," "\n")

  for addr in $origins
  do
      echo "  - $addr" >> /etc/graphite-api.yaml
  done
fi

/etc/init.d/grafana-server start

git clone https://github.com/rackerlabs/blueflood-grafana-graphite_api-plugin.git /var/lib/grafana/plugins

gunicorn -b 0.0.0.0:8888 --access-logfile /var/log/gunicorn-access.log --error-logfile /var/log/gunicorn-error.log -w 8 graphite_api.app:app

#allows gunicorn to be restarted without exiting docker container
sleep 10000000
