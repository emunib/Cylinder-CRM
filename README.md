# Cylinder CRM

A easy to use crm built in java.  

## How to Build

- Install Gradle
	- https://gradle.org/install/
- Provide the database connection properties in `src/main/resources/application.properties` file. 
- Generate the tables/schemas for the database
	- We only have a postgres schema which can be found `src/main/resources/schema.sql` 
- Run `gradle wrapper` 
- Run `./gradlew bootRun`
- Open a browser to `localhost:8080`
- Default admin user `admin@admin.com` is created with the password `p@ssw0rd123Me`

## Notes

- This project was done in partial fulfillment for CMPT 370. 




