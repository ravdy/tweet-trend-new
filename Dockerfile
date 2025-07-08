# Use lightweight OpenJDK base image
FROM openjdk:17-jdk-slim

# Set working directory inside container
WORKDIR /app

# Copy JAR from build context to image
COPY target/demo-workshop-2.1.2.jar ttrend.jar

# Expose the app port (if applicable)
EXPOSE 8080

# Run the Spring Boot app
ENTRYPOINT ["java", "-jar", "ttrend.jar"]
