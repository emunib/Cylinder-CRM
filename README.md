# Cylinder CRM

A easy to use crm built in java.  

## How to Build

- Install Gradle
	- https://gradle.org/install/
- Provide the database connection properties in `src/main/resources/application.properties` file. 
	- See the application.properties [reference](https://docs.spring.io/spring-boot/docs/current/reference/html/common-application-properties.html) in particular you'll be interested in the JPA section. 
- Generate the tables/schemas for the database
	- We only have a postgres schema which can be found in `schema.sql` 
- Run `gradle wrapper` 
- Run `./gradlew bootRun`
- Open a browser to `localhost:8080`
- Default admin user `admin@admin.com` is created with the password `p@ssw0rd123Me`

## Notes

- This project was done in partial fulfillment for CMPT 370. 




