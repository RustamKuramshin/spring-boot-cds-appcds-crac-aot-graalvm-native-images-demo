#!/usr/bin/env bash

echo "Создаем checkpoint для petclinic-crac..."
docker exec petclinic-crac jcmd spring-petclinic.jar JDK.checkpoint
