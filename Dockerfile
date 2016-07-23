FROM python:2.7

MAINTAINER gaurav.bajaj@rackspace.com

RUN apt-get update && \
    apt-get install -y git --force-yes && \
    apt-get install -y build-essential --force-yes && \
    apt-get install -y libcairo2-dev --force-yes && \
    apt-get install -y libffi-dev --force-yes && \
    pip install gunicorn &&\
	pip install --upgrade "git+http://github.com/rackerlabs/graphite-api.git@george/fetch_multi_with_patches" &&\
	pip install --upgrade blueflood-graphite-finder

COPY ./docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 8888

ENTRYPOINT ["/docker-entrypoint.sh"]

