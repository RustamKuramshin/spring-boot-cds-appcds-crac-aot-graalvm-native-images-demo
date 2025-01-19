#!/usr/bin/env bash

docker build -t petclinica .
docker run petclinica:latest

docker build -t petclinica-cds -f DockerfileCDS .
docker run petclinica-cds:latest

docker build -t petclinica-aot-optimizations -f DockerfileAOTOptimizations .
docker run petclinica-aot-optimizations

docker build -t petclinica-native -f DockerfileNative .
docker run petclinica-native
