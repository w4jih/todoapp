# ---- Runtime image ----
FROM eclipse-temurin:21-jre
WORKDIR /app

# JAR built by Maven: target/<artifact>.jar
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
