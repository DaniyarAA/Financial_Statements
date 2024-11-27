FROM maven:3.9.8-amazoncorretto-21 AS build
WORKDIR /build
COPY src ./src
COPY pom.xml ./
RUN mvn clean package -DskipTests

FROM openjdk:21
WORKDIR /app
COPY --from=build /build/target/*.jar ./financial_statement.jar
EXPOSE 8081
CMD ["java", "-jar", "financial_statement.jar"]