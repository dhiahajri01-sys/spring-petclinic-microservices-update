FROM eclipse-temurin:17 AS builder
WORKDIR /app

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

COPY spring-petclinic-config-server/pom.xml ./spring-petclinic-config-server/
COPY spring-petclinic-discovery-server/pom.xml ./spring-petclinic-discovery-server/
COPY spring-petclinic-customers-service/pom.xml ./spring-petclinic-customers-service/
COPY spring-petclinic-visits-service/pom.xml ./spring-petclinic-visits-service/
COPY spring-petclinic-vets-service/pom.xml ./spring-petclinic-vets-service/
COPY spring-petclinic-genai-service/pom.xml ./spring-petclinic-genai-service/
COPY spring-petclinic-admin-server/pom.xml ./spring-petclinic-admin-server/
COPY spring-petclinic-api-gateway/pom.xml ./spring-petclinic-api-gateway/

COPY spring-petclinic-config-server/src ./spring-petclinic-config-server/src/
COPY spring-petclinic-discovery-server/src ./spring-petclinic-discovery-server/src/
COPY spring-petclinic-customers-service/src ./spring-petclinic-customers-service/src/
COPY spring-petclinic-visits-service/src ./spring-petclinic-visits-service/src/
COPY spring-petclinic-vets-service/src ./spring-petclinic-vets-service/src/
COPY spring-petclinic-genai-service/src ./spring-petclinic-genai-service/src/
COPY spring-petclinic-admin-server/src ./spring-petclinic-admin-server/src/
COPY spring-petclinic-api-gateway/src ./spring-petclinic-api-gateway/src/

# FIX: Make mvnw executable
RUN chmod +x mvnw

RUN ./mvnw clean package -pl spring-petclinic-api-gateway -am -DskipTests

FROM eclipse-temurin:17
WORKDIR /app

COPY --from=builder /app/spring-petclinic-api-gateway/target/spring-petclinic-api-gateway-4.0.1.jar app.jar

EXPOSE 8080
ENV SPRING_PROFILES_ACTIVE=default
ENV SPRING_CLOUD_CONFIG_ENABLED=false
ENV EUREKA_CLIENT_ENABLED=false

ENTRYPOINT ["java", "-jar", "app.jar"]
