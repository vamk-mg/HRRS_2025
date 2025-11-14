# Stage 1: Build the Spring Boot app
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy pom.xml and download dependencies for caching
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build JAR without running tests
RUN mvn clean package -DskipTests

# Stage 2: Run the app
FROM eclipse-temurin:17-jdk
WORKDIR /app

# Copy the JAR from Stage 1 (wildcard ensures correct name)
COPY --from=build /app/target/*.jar room-app.jar

# Expose port 8080
EXPOSE 8089

# Run Spring Boot app
ENTRYPOINT ["java","-jar","room-app.jar"]
