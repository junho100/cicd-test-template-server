FROM openjdk:17-jdk-slim as builder

COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
COPY gradle.properties .
COPY src src
RUN chmod +x ./gradlew
RUN ./gradlew bootJar

FROM openjdk:17-jdk-slim

WORKDIR /app

COPY --from=builder build/libs/*.jar app.jar

ARG db_host
ARG db_name
ARG db_user
ARG db_password

ENV DB_HOST=$db_host
ENV DB_NAME=$db_name
ENV DB_USERNAME=$db_user
ENV DB_PASSWORD=$db_password

EXPOSE 9090
ENTRYPOINT java -jar app.jar