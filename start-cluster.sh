#!/bin/bash

docker-machine create -d virtualbox local
eval $(docker-machine env local)
docker run swarm create > token.txt
export TOKEN="`cat token.txt`"

docker-machine create \
        -d virtualbox \
        --swarm \
        --swarm-master \
        --swarm-discovery token://$TOKEN \
        swarm-master

docker-machine create \
    -d virtualbox \
    --swarm \
    --swarm-discovery token://$TOKEN \
    --engine-label role=haproxy \
    swarm-haproxy-node

docker-machine create \
    -d virtualbox \
    --swarm \
    --swarm-discovery token://$TOKEN \
    --engine-label role=worker \
    swarm-worker-node-00

docker-machine create \
    -d virtualbox \
    --swarm \
    --swarm-discovery token://$TOKEN \
    --engine-label role=worker \
    swarm-worker-node-01

docker-machine create \
    -d virtualbox \
    --swarm \
    --swarm-discovery token://$TOKEN \
    --engine-label role=worker \
    swarm-worker-node-02

sleep 20

eval $(docker-machine env --swarm swarm-master)
docker info

