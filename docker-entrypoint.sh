#!/bin/bash -x

: ${BLUEFLOOD_QUERY_URL="http://localhost:20000"}
: ${TENANT_ID="123"}
: ${GRAFANA_URLS="http://localhost:3000"}

exec 2>&1
exec 1>/tmp/bash-debug.log
apt-get update -y --force-yes

if [[ -z "$RAX_USERNAME" ]] ||  [[ -z "$RAX_APIKEY" ]]
then
cat > /etc/graphite-api.yaml << EOL
search_index: /dev/null
finders:
  - blueflood.TenantBluefloodFinder
functions:
  - graphite_api.functions.SeriesFunctions
  - graphite_api.functions.PieFunctions
time_zone: UTC
blueflood:
  tenant: $TENANT_ID
  urls:
    - $BLUEFLOOD_QUERY_URL
allowed_origins:
EOL
else
cat > /etc/graphite-api.yaml << EOL
search_index: /dev/null
finders:
  - blueflood.TenantBluefloodFinder
functions:
  - graphite_api.functions.SeriesFunctions
  - graphite_api.functions.PieFunctions
time_zone: UTC
blueflood:
  tenant: $TENANT_ID
  username: $RAX_USERNAME             
  apikey: $RAX_APIKEY                     
  authentication_module: rax_auth
  authentication_class: BluefloodAuth
  urls:
    - $BLUEFLOOD_QUERY_URL
allowed_origins:
EOL
fi

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

gunicorn -b 0.0.0.0:8888 --access-logfile /var/log/gunicorn-access.log --error-logfile /var/log/gunicorn-error.log -w 8 graphite_api.app:app