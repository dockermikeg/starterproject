#!/bin/bash

docker-machine stop local
docker-machine stop swarm-master
docker-machine stop swarm-haproxy-node
docker-machine stop swarm-worker-node-00
docker-machine stop swarm-worker-node-01
docker-machine stop swarm-worker-node-02

docker-machine rm local
docker-machine rm swarm-master
docker-machine rm swarm-haproxy-node
docker-machine rm swarm-worker-node-00
docker-machine rm swarm-worker-node-01
docker-machine rm swarm-worker-node-02



