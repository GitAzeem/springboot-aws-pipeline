# Use a lightweight OpenJDK base image
FROM openjdk:21-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the built JAR from your local machine into the container
COPY journalapp/target/CampusConnect-0.0.1-SNAPSHOT.jar app.jar

# Expose the port your Spring Boot app uses
EXPOSE 9090

# Run the Spring Boot app
ENTRYPOINT ["java", "-jar", "app.jar"]
