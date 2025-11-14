# Stage 1: Build Spring Boot App using Maven
FROM maven:3.9.6-openjdk-17 AS build
WORKDIR /app

# Copy Maven descriptor first for dependency caching
COPY pom.xml .

# Download dependencies for offline build
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build application JAR (skip tests for faster build)
RUN mvn clean package -DskipTests

# Stage 2: Run the Spring Boot app
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

# Copy built JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the port your app uses
EXPOSE 8089

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
