DROP DATABASE IF EXISTS wonderland_elections_db;
CREATE DATABASE wonderland_elections_db;
USE wonderland_elections_db;

CREATE TABLE FOLK (
  PIN CHAR(16) PRIMARY KEY,
  first_name VARCHAR(40),
  last_name VARCHAR(40),
  nickname VARCHAR(40),
  date_of_birth DATE,
  primary_phone CHAR(10),
  secondary_phone CHAR(10),
  
  -- To enforce that the must contain exactly 16 digits. 
  CONSTRAINT chk_pin_format CHECK (PIN REGEXP '^[0-9]{16}$')
);

CREATE TABLE FOLK_EMAIL (
  PIN CHAR(16),
  email VARCHAR(80),
  PRIMARY KEY (PIN, email),
  FOREIGN KEY (PIN) REFERENCES FOLK(PIN)
);

CREATE TABLE PLACE (
  place_id INT AUTO_INCREMENT PRIMARY KEY,
  street_no VARCHAR(10),
  street_name VARCHAR(60),
  city VARCHAR(40),
  state CHAR(2),
  zipcode CHAR(5),
  x FLOAT,
  y FLOAT,
  UNIQUE(street_no, street_name, city, state, zipcode),
  UNIQUE(x, y)
);

CREATE TABLE RESIDENCE (
  place_id INT PRIMARY KEY,
  FOREIGN KEY (place_id) REFERENCES PLACE(place_id)
);

CREATE TABLE VOTING_CENTER (
  place_id INT PRIMARY KEY,
  acronym CHAR(4) UNIQUE,
  FOREIGN KEY (place_id) REFERENCES PLACE(place_id)
);

CREATE TABLE OPERATING_PERIOD (
  center_id INT,
  start_dt DATETIME,
  end_dt DATETIME,
  PRIMARY KEY (center_id, start_dt, end_dt),
  FOREIGN KEY (center_id) REFERENCES VOTING_CENTER(place_id),
  CHECK (start_dt < end_dt)
);


CREATE TABLE STAFF (
  PIN CHAR(16) PRIMARY KEY,
  role_type ENUM('clerk','monitor'),
  FOREIGN KEY (PIN) REFERENCES FOLK(PIN)
);


CREATE TABLE STAFF_ASSIGNMENT (
  PIN CHAR(16),
  center_id INT,
  start_dt DATETIME,
  end_dt DATETIME,
  PRIMARY KEY (PIN, center_id, start_dt, end_dt),
  FOREIGN KEY (PIN) REFERENCES STAFF(PIN),
  FOREIGN KEY (center_id) REFERENCES VOTING_CENTER(place_id),
  CHECK (start_dt < end_dt)
);

CREATE TABLE POLL (
  poll_code CHAR(4) PRIMARY KEY,
  question_text VARCHAR(255),
  availability_start_dt DATETIME,
  availability_end_dt DATETIME,
  CHECK (availability_start_dt < availability_end_dt)
);

CREATE TABLE REGISTRATION (
  registration_id INT AUTO_INCREMENT PRIMARY KEY,
  PIN CHAR(16),
  center_id INT,
  voting_date DATE,
  poll_code CHAR(4),
  FOREIGN KEY (PIN) REFERENCES FOLK(PIN),
  FOREIGN KEY (center_id) REFERENCES VOTING_CENTER(place_id)
);

CREATE TABLE BALLOT (
  ballot_id INT AUTO_INCREMENT PRIMARY KEY,
  registration_id INT,
  poll_code CHAR(4),
  choice ENUM('YES','NO','ABSTAIN') DEFAULT NULL,
  cast_dt DATETIME,
  FOREIGN KEY (registration_id) REFERENCES REGISTRATION(registration_id),
  FOREIGN KEY (poll_code) REFERENCES POLL(poll_code),
  UNIQUE (registration_id, poll_code)
);
-- o improve query performance for reporting and analytics, an index was created here on the REGISTRATION(center_id, voting_date) columns.
CREATE INDEX idx_registration_center_date
ON REGISTRATION(center_id, voting_date);

SHOW DATABASES;
USE wonderland_elections_db;
SHOW TABLES;

DESCRIBE FOLK;
DESCRIBE BALLOT;