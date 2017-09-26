FROM python:2.7

MAINTAINER gaurav.bajaj@rackspace.com

RUN apt-get update && \
    apt-get install -y git --force-yes && \
    apt-get install -y build-essential --force-yes && \
    apt-get install -y libcairo2-dev --force-yes && \
    apt-get install -y libffi-dev --force-yes && \
    pip install gunicorn && \
    pip install --upgrade "git+http://github.com/rackerlabs/graphite-api.git@1.1.3-rax.1" && \
    pip install --upgrade blueflood-graphite-finder && \
    apt-get install -y vim apt-transport-https && \
    echo "deb https://packagecloud.io/grafana/stable/debian/ jessie main" >> /etc/apt/sources.list && \
    curl https://packagecloud.io/gpg.key | apt-key add - && \
    apt-get update && \
    apt-get install -y grafana 

COPY ./docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 3000
EXPOSE 8888

ENTRYPOINT ["/docker-entrypoint.sh"]

