# CarVerse 🚗

**CarVerse** is a full-stack web application for browsing, comparing, and purchasing cars online — built using Advanced Java (JSP/Servlets, JDBC/Hibernate) with MySQL as the backend database.

## About the Project

CarVerse lets users explore cars across multiple categories, compare specifications side-by-side, book/purchase a car, and manage post-purchase maintenance — all in one platform. Admins can manage car listings, categories, and service records through a dedicated dashboard.

## Modules

- **User** – Registration, login, browse cars, purchase, view history
- **Car Categories** – Organize cars by type (SUV, Sedan, Electric, etc.)
- **Car Comparisons** – Compare specs of multiple cars side-by-side
- **Car Maintenance** – Schedule and track service appointments
- **Admin** – Manage cars, categories, users, and maintenance records

## Tech Stack

- **Backend:** Java, Servlets, JSP, JDBC / Hibernate
- **Frontend:** HTML, CSS, JavaScript (Bootstrap)
- **Database:** MySQL
- **Server:** Apache Tomcat

## Status

🚧 Project under development.

## Getting Started

Setup instructions coming soon.

## Password security setup

Run `src/main/webapp/WEB-INF/password_security_migration.sql` once as the `CARVERSE` schema owner. It widens the customer password column; existing customer plaintext passwords and older business hashes upgrade to PBKDF2 after successful login.

Demo password recovery accepts account email and new password directly. It does not send email or verify email ownership. Do not use this recovery flow in production. Passwords are stored as PBKDF2 hashes.

## License

This project is for educational purposes.
