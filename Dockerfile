FROM openjdk:21
RUN mkdir /app
COPY ./financial_statement*.jar ./app/financial_statement.jar
WORKDIR /app

EXPOSE 8089
CMD ["java", "-jar", "financial_statement.jar"]