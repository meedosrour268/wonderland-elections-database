USE wonderland_elections_db;

INSERT INTO FOLK (PIN, first_name, last_name, nickname, date_of_birth, primary_phone, secondary_phone) VALUES
('0000000000000001', 'Mahmoud', 'Meedo', 'Srour', '1990-05-10', '4105551234', '4105555678'),
('0000000000000002', 'Sedra', 'Wife', 'Hammash', '1985-09-22', '4105559876', '4105554321'),
('0000000000000003', 'Charlie', 'Rabbit', 'Factory', '1992-12-01', '4435551111', '4435552222');

INSERT INTO FOLK_EMAIL (PIN, email) VALUES
('0000000000000001', 'mahmoud@wonderland.com'),
('0000000000000002', 'sedra@wonderland.com'),
('0000000000000003', 'charlie@wonderland.com');

INSERT INTO PLACE (street_no, street_name, city, state, zipcode, x, y) VALUES
('101', 'Tea St', 'Megapolis', 'WL', '12345', 0.0, 0.0),
('202', 'Rabbit Rd', 'Megapolis', 'WL', '12346', 2.5, 3.1),
('303', 'Queen Blvd', 'Megapolis', 'WL', '12347', 5.8, 4.2);

INSERT INTO RESIDENCE (place_id) VALUES (1), (2);

INSERT INTO VOTING_CENTER (place_id, acronym) VALUES
(3, 'VC01');

INSERT INTO OPERATING_PERIOD (center_id, start_dt, end_dt) VALUES
(3, '2025-11-15 08:00:00', '2025-11-15 18:00:00'),
(3, '2025-11-16 08:00:00', '2025-11-16 18:00:00');

INSERT INTO STAFF (PIN, role_type) VALUES
('0000000000000001', 'clerk'),
('0000000000000002', 'monitor');

INSERT INTO STAFF_ASSIGNMENT (PIN, center_id, start_dt, end_dt) VALUES
('0000000000000001', 3, '2025-11-15 08:00:00', '2025-11-15 18:00:00'),
('0000000000000002', 3, '2025-11-16 08:00:00', '2025-11-16 18:00:00');

INSERT INTO POLL (poll_code, question_text, availability_start_dt, availability_end_dt) VALUES
('P001', 'Should Wonderland adopt electronic ballots to make life easier?', '2025-11-15 00:00:00', '2025-11-20 23:59:59'),
('P002', 'Should voting age be lowered to 16 or maybe even lower to make it fair?', '2025-11-15 00:00:00', '2025-11-20 23:59:59');


INSERT INTO REGISTRATION (PIN, center_id, voting_date) VALUES
('0000000000000001', 3, '2025-11-15'),
('0000000000000002', 3, '2025-11-16');


INSERT INTO BALLOT (registration_id, poll_code, choice, cast_dt) VALUES
(1, 'P001', 'YES', '2025-11-15 09:45:00'),
(2, 'P002', 'NO', '2025-11-16 10:30:00');

INSERT INTO FOLK (PIN, first_name, last_name, nickname, date_of_birth, primary_phone, secondary_phone) VALUES
('0000000000000004', 'Alice', 'Liddell', 'Dreamer', '1995-04-12', '4105558765', '4105553333'),
('0000000000000005', 'Mad', 'Hatter', 'Tea', '1980-03-25', '4105559999', '4105550000');

INSERT INTO FOLK_EMAIL (PIN, email) VALUES
('0000000000000004', 'alice@wonderland.com'),
('0000000000000005', 'hatter@wonderland.com');

INSERT INTO PLACE (street_no, street_name, city, state, zipcode, x, y) VALUES
('404', 'Hatter St', 'Wondercity', 'WL', '12348', 8.0, 8.0),
('505', 'March Ave', 'Wondercity', 'WL', '12349', 9.2, 9.5);

INSERT INTO VOTING_CENTER (place_id, acronym) VALUES
(4, 'VC02'),
(5, 'VC03');

INSERT INTO REGISTRATION (PIN, center_id, voting_date, poll_code) VALUES
('0000000000000003', 3, '2025-11-15'),
('0000000000000004', 4, '2025-11-15'),
('0000000000000005', 5, '2025-11-16');


SELECT* FROM FOLK;
