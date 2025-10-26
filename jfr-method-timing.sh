#!/usr/bin/env bash

java \
"-XX:StartFlightRecording=filename=petclinic-$(date +%Y%m%d-%H%M%S).jfr,dumponexit=true,disk=true,settings=profile,method-timing=\
java.lang.reflect.Method::invoke;java.lang.reflect.Constructor::newInstance;\
java.lang.reflect.Field::get;java.lang.reflect.Field::set;\
java.lang.Class::forName;java.lang.ClassLoader::loadClass;\
java.lang.Class::getDeclaredMethods;java.lang.Class::getDeclaredFields;java.lang.Class::getDeclaredConstructors;\
java.lang.reflect.AnnotatedElement::getAnnotationsByType;java.lang.reflect.AnnotatedElement::getDeclaredAnnotationsByType;\
java.lang.reflect.AccessibleObject::trySetAccessible;java.lang.reflect.AccessibleObject::setAccessible;\
java.lang.invoke.MethodHandles$Lookup::findConstructor;java.lang.invoke.MethodHandles$Lookup::findVirtual;java.lang.invoke.MethodHandles$Lookup::findStatic;java.lang.invoke.MethodHandles$Lookup::unreflect;java.lang.invoke.MethodHandles$Lookup::unreflectConstructor;java.lang.invoke.MethodHandles$Lookup::unreflectSpecial;\
java.lang.invoke.VarHandle::get;java.lang.invoke.VarHandle::set;java.lang.invoke.VarHandle::compareAndSet;\
java.lang.reflect.Array::newInstance;\
org.springframework.aop.framework.JdkDynamicAopProxy::invoke;org.springframework.aop.framework.ReflectiveMethodInvocation::proceed" \
-jar target/spring-petclinic-3.4.0-SNAPSHOT.jar --spring.profiles.active=postgres


# Потом выполнить
# jfr view method-timing petclinic-*.jfr
