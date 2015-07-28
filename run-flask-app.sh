#!/bin/bash

docker run -d \
        -p 80:8080 \
        -e constraint:role==haproxy \
        -v /var/lib/boot2docker:/etc/docker  ehazlett/interlock \
        --swarm-url $DOCKER_HOST \
        --swarm-tls-ca-cert=/etc/docker/ca.pem \
        --swarm-tls-cert=/etc/docker/server.pem \
        --swarm-tls-key=/etc/docker/server-key.pem \
        --plugin haproxy start

docker run -d \
        --name db \
        -e constraint:node==swarm-worker-node-00  \
        dockermikeg/postgres

# edit local /etc/hosts file to include mikegraboski.com
docker run -d \
        -p 5000:5000 \
        --name webfe \
        --hostname www.mikegraboski.com \
        --link db:db \
        -e constraint:role==worker \
        -e INTERLOCK_DATA='{"hostname":"mikegraboski.com", "domain":"mikegraboski.com", "port":5000}' \
        dockermikeg/flask