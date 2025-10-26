#!/usr/bin/env bash

java \
  "-XX:StartFlightRecording=filename=petclinic.jfr,settings=profile,method-timing=\
java.lang.reflect.Method::invoke;java.lang.reflect.Constructor::newInstance;\
java.lang.reflect.Field::get;java.lang.reflect.Field::set;\
java.lang.Class::forName;java.lang.reflect.Proxy::newProxyInstance" \
  -jar target/spring-petclinic-3.4.0-SNAPSHOT.jar --spring.profiles.active=postgres

# Потом выполнить
# jfr view method-timing petclinic.jfr
