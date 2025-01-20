#!/usr/bin/env bash

docker build -t petclinica .
docker run petclinica:latest

docker build -t petclinica-cds -f DockerfileCDS .
docker run petclinica-cds:latest

docker build -t petclinica-aot-optimizations -f DockerfileAOT .
docker run petclinica-aot-optimizations

docker build -t petclinica-native -f DockerfileNative .
docker run petclinica-native

jcmd spring-petclinic.jar JDK.checkpoint
docker build --progress=plain -t petclinica-crac-ff -f DockerfileCRaC .
#docker buildx build --progress=plain --allow security.insecure --load -t petclinica-crac-ff -f DockerfileCRaC .
docker run -it --cap-add=CHECKPOINT_RESTORE --cap-add=SYS_PTRACE --rm --name petclinica-crac-ff-checkpoint -v $PWD/crac-files:/app/crac-files petclinica-crac-ff java -Dspring.context.checkpoint=onRefresh -XX:CRaCCheckpointTo=/app/crac-files -jar spring-petclinic.jar
#docker run -it --cap-add=CHECKPOINT_RESTORE --cap-add=SYS_PTRACE --rm --name petclinica-crac-ff -v $PWD/crac-files:/app/crac-files petclinica-crac-ff java -XX:CRaCCheckpointTo=/app/crac-files -jar spring-petclinic.jar
docker exec petclinica-crac-ff jcmd spring-petclinic.jar JDK.checkpoint
docker run -it --cap-add=CHECKPOINT_RESTORE --cap-add=SYS_PTRACE --rm --name petclinica-crac-ff-restore -v $PWD/crac-files:/app/crac-files petclinica-crac-ff java -XX:CRaCRestoreFrom=/app/crac-files

docker compose --progress=plain up -d petclinic
docker compose --progress=plain up -d petclinic-aot
docker compose --progress=plain up -d petclinic-cds
docker compose --progress=plain up -d petclinic-crac
docker compose --progress=plain up -d petclinic-native
