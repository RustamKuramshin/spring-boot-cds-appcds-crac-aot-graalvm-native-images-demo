#!/usr/bin/env bash

echo "Восстанавливаем petclinic-crac из checkpoint..."
CRAC_RESTORE=true docker-compose up -d petclinic-crac
