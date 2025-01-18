#!/usr/bin/env bash

docker build -t petclinica .

docker run petclinica:latest

docker build -t petclinica-cds -f DockerfileCDS .

docker run petclinica-cds:latest
