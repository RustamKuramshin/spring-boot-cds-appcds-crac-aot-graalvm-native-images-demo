#!/usr/bin/env bash

# Определяем ОС
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  JAVA_HOME="$(/usr/libexec/java_home -v 17)"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Linux
  JAVA_HOME="/usr/lib/jvm/java-17-openjdk"
else
  echo "Unsupported OS: $OSTYPE"
  exit 1
fi

# Устанавливаем JAVA_HOME и обновляем PATH
export JAVA_HOME
export PATH=$JAVA_HOME/bin:$PATH

# Проверяем текущую версию Java
echo "Using Java version:"
java -version

# Пересборка проекта с Maven Wrapper и отключением тестов
echo "Building the project with Maven Wrapper (skipping tests)..."
./mvnw clean package -DskipTests

# Проверяем, что сборка прошла успешно
if [[ $? -ne 0 ]]; then
  echo "Build failed. Exiting..."
  exit 1
fi

POSTGRES_URL="jdbc:postgresql://localhost:35432/petclinic"
export POSTGRES_URL

java -jar target/spring-petclinic-*.jar --spring.profiles.active=postgres
