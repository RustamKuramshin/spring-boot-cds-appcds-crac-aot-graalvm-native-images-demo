FROM cr.int.axiomjdk.ru/axiom-linux-23/axiom-runtime-container-pro:jdk-17-musl AS builder
WORKDIR /builder

COPY pom.xml ./
COPY mvnw .
COPY .mvn .mvn

RUN ./mvnw verify --fail-never

COPY src ./src

RUN ./mvnw clean package -DskipTests

FROM cr.int.axiomjdk.ru/axiom-linux-23/axiom-runtime-container-pro:jre-17-musl AS extractor
WORKDIR /extractor

COPY --from=builder /builder/target/spring-petclinic-*.jar /extractor/spring-petclinic.jar

RUN java -Djarmode=tools -jar spring-petclinic.jar extract --layers --destination extracted

FROM cr.int.axiomjdk.ru/axiom-linux-23/axiom-runtime-container-pro:jre-17-musl
WORKDIR /app

COPY --from=extractor /extractor/extracted/dependencies/ ./
COPY --from=extractor /extractor/extracted/spring-boot-loader/ ./
COPY --from=extractor /extractor/extracted/snapshot-dependencies/ ./
COPY --from=extractor /extractor/extracted/application/ ./

CMD ["java", "-jar", "spring-petclinic.jar"]
