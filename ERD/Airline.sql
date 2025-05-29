-- Airline Information System SQL Schema (Based on latest ERD)

USE AirlineDB;

-- 1. AIRPORT
CREATE TABLE AIRPORT (
    airport_code CHAR(5) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL
);

-- 2. AIRPLANE_TYPE
CREATE TABLE AIRPLANE_TYPE (
    type_name VARCHAR(50) PRIMARY KEY,
    company VARCHAR(100),
    max_seats INT CHECK (max_seats > 0)
);

-- 3. AIRPLANE
CREATE TABLE AIRPLANE (
    airplane_id INT PRIMARY KEY,
    specific_type VARCHAR(50) NOT NULL,
    total_number_of_seats INT NOT NULL CHECK (total_number_of_seats > 0),
    FOREIGN KEY (specific_type) REFERENCES AIRPLANE_TYPE(type_name)
);

-- 4. FLIGHT_LEG
CREATE TABLE FLIGHT_LEG (
    leg_no INT PRIMARY KEY,
    departure_airport CHAR(5) NOT NULL,
    arrival_airport CHAR(5) NOT NULL,
    scheduled_dep_time TIME NOT NULL,
    scheduled_arr_time TIME NOT NULL,
    FOREIGN KEY (departure_airport) REFERENCES AIRPORT(airport_code)
        ON DELETE NO ACTION ON UPDATE CASCADE,
    FOREIGN KEY (arrival_airport) REFERENCES AIRPORT(airport_code)
        ON DELETE NO ACTION ON UPDATE CASCADE
);

-- 5. LEG_INSTANCE
CREATE TABLE LEG_INSTANCE (
    instance_id INT PRIMARY KEY,
    leg_no INT NOT NULL,
    airplane_id INT NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    available_seats INT CHECK (available_seats >= 0),
    FOREIGN KEY (leg_no) REFERENCES FLIGHT_LEG(leg_no)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (airplane_id) REFERENCES AIRPLANE(airplane_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 6. SEAT_RESERVATION
CREATE TABLE SEAT_RESERVATION (
    reservation_id INT PRIMARY KEY,
    instance_id INT NOT NULL,
    seat_no VARCHAR(5) NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    customer_phone VARCHAR(20),
    FOREIGN KEY (instance_id) REFERENCES LEG_INSTANCE(instance_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 7. FLIGHT
CREATE TABLE FLIGHT (
    flight_id INT PRIMARY KEY,
    airline VARCHAR(100) NOT NULL,
    weekdays VARCHAR(50),
    restrictions TEXT
);

-- 8. FLIGHT_LEG_MAPPING
CREATE TABLE FLIGHT_LEG_MAPPING (
    flight_id INT,
    leg_no INT,
    PRIMARY KEY (flight_id, leg_no),
    FOREIGN KEY (flight_id) REFERENCES FLIGHT(flight_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (leg_no) REFERENCES FLIGHT_LEG(leg_no)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 9. FARE
CREATE TABLE FARE (
    code VARCHAR(10) PRIMARY KEY,
    flight_id INT NOT NULL,
    amount DECIMAL(10,2) CHECK (amount >= 0),
    FOREIGN KEY (flight_id) REFERENCES FLIGHT(flight_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);


---- Backup the database to a safe path

BACKUP DATABASE CompanyDB
TO DISK = 'C:\Users\codel\OneDrive\Desktop\DATA.BASE\DataBase\Airline_Backup1.bak'
WITH FORMAT,
NAME = 'Full Backup of Airline';

-- ============================================================
-- SQL tables match the updated ER diagram structure:
-- - AIRPORT connected to FLIGHT_LEG (arrival/departure)
-- - AIRPLANE ↔ AIRPLANE_TYPE via type
-- - FLIGHT includes multiple legs
-- - LEG_INSTANCE ties legs to planes and SEAT_RESERVATION
-- - FLIGHT has multiple FARE options
-- ============================================================