# Stage 1: Build Spring Boot App
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy Maven descriptor first to cache dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the JAR (skip tests for speed)
RUN mvn clean package -DskipTests -B

# Stage 2: Run Spring Boot App
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

# Copy built JAR from build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port used by the app
EXPOSE 8089

# Run Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
