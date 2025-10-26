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

FROM cr.int.axiomjdk.ru/axiom-linux-23/axiom-runtime-container-pro:jdk-17-musl
WORKDIR /app

# Directory for JFR snapshots (mounted from host via docker-compose)
RUN mkdir -p /jfr

COPY --from=extractor /extractor/extracted/dependencies/ ./
COPY --from=extractor /extractor/extracted/spring-boot-loader/ ./
COPY --from=extractor /extractor/extracted/snapshot-dependencies/ ./
COPY --from=extractor /extractor/extracted/application/ ./

# Always record JFR at startup
CMD ["sh", "-c", "exec java -XX:+FlightRecorder -XX:StartFlightRecording=duration=20m,name=${SPRING_APPLICATION_NAME:-petclinic},settings=profile,filename=/jfr/${SPRING_APPLICATION_NAME:-petclinic}-$(date +%Y%m%d-%H%M%S).jfr,dumponexit=true,disk=true -Djdk.tracePinnedThreads=full -Djdk.tracePinnedThreads.warning=true -Djdk.traceVirtualThreadLocals=true -jar spring-petclinic.jar"]
