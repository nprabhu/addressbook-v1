# ----------------------
# Stage 1: Build with Maven
# ----------------------
FROM maven:3.9.9-eclipse-temurin-17 AS builder

# Set working dir
WORKDIR /app

# Copy project files
COPY pom.xml .
COPY src ./src

# Build WAR
RUN mvn clean package -DskipTests

# ----------------------
# Stage 2: Run with Tomcat
# ----------------------
FROM tomcat:9.0-jdk17-temurin

# Clean out default webapps (optional)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR from builder
COPY --from=builder /app/target/addressbook.war /usr/local/tomcat/webapps/addressbook.war

# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
