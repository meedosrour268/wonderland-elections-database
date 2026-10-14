USE wonderland_elections_db;
-- Using the 
-- B.1: queries B.1-B.10 (on page 5-6) required for the project.

SELECT DISTINCT f.first_name, f.last_name, p.city, fe.email
FROM FOLK f
LEFT JOIN REGISTRATION r ON f.PIN = r.PIN
LEFT JOIN VOTING_CENTER vc ON r.center_id = vc.place_id
LEFT JOIN PLACE p ON vc.place_id = p.place_id
LEFT JOIN FOLK_EMAIL fe ON f.PIN = fe.PIN;


-- B.2:

SELECT p.city, p.state, COUNT(r.place_id) AS num_residents
FROM RESIDENCE r
JOIN PLACE p ON r.place_id = p.place_id
GROUP BY p.city, p.state
HAVING num_residents > 0
ORDER BY num_residents DESC;

-- B.3:

SELECT p.zipcode, vc.acronym, COUNT(r.registration_id) AS num_registered
FROM VOTING_CENTER vc
LEFT JOIN PLACE p ON vc.place_id = p.place_id
LEFT JOIN REGISTRATION r ON vc.place_id = r.center_id
GROUP BY vc.acronym, p.zipcode
ORDER BY p.zipcode ASC;

-- B.4:

SET @center_id = 3;
SET @start_dt = '2025-11-10';
SET @end_dt = '2025-11-20';

SELECT DISTINCT f.PIN, f.first_name, f.last_name
FROM FOLK f
JOIN REGISTRATION r ON f.PIN = r.PIN
WHERE r.center_id = @center_id
  AND r.voting_date BETWEEN @start_dt AND @end_dt;
  

-- B.5:

SET @month = '2025-11';
SET @exclude1 = 'VC02';
SET @exclude2 = 'VC03';

SELECT COUNT(DISTINCT r.registration_id) AS unique_registrations
FROM REGISTRATION r
JOIN VOTING_CENTER vc ON r.center_id = vc.place_id
JOIN PLACE p ON vc.place_id = p.place_id
WHERE DATE_FORMAT(r.voting_date, '%Y-%m') = @month
  AND SQRT(POW(p.x - 0.0, 2) + POW(p.y - 0.0, 2)) <= 3
  AND vc.acronym NOT IN (@exclude1, @exclude2);

-- B.6:

SET @city = 'Megapolis';
SET @start_period = '2025-11-01';
SET @end_period = '2025-11-30';

WITH city_counts AS (
    SELECT vc.acronym, COUNT(r.registration_id) AS total_regs
    FROM REGISTRATION r
    JOIN VOTING_CENTER vc ON r.center_id = vc.place_id
    JOIN PLACE p ON vc.place_id = p.place_id
    WHERE p.city = @city
      AND r.voting_date BETWEEN @start_period AND @end_period
    GROUP BY vc.acronym
)
SELECT acronym, total_regs
FROM city_counts
WHERE total_regs = (SELECT MAX(total_regs) FROM city_counts);

-- B.7

SET @state = 'WL';

SELECT f.PIN, f.first_name, f.last_name
FROM FOLK f
JOIN REGISTRATION r ON f.PIN = r.PIN
JOIN VOTING_CENTER vc ON r.center_id = vc.place_id
JOIN PLACE p ON vc.place_id = p.place_id
WHERE p.state = @state
GROUP BY f.PIN
HAVING COUNT(DISTINCT vc.place_id) = (
    SELECT COUNT(*)
    FROM VOTING_CENTER vc2
    JOIN PLACE p2 ON vc2.place_id = p2.place_id
    WHERE p2.state = @state
);

-- B.8:

SELECT DISTINCT f.PIN, f.first_name, f.last_name
FROM FOLK f
JOIN REGISTRATION r ON f.PIN = r.PIN
JOIN VOTING_CENTER vc ON r.center_id = vc.place_id
JOIN PLACE p_vc ON vc.place_id = p_vc.place_id
JOIN RESIDENCE re ON re.place_id = re.place_id
JOIN PLACE p_res ON re.place_id = p_res.place_id
WHERE SQRT(POW(p_vc.x - p_res.x, 2) + POW(p_vc.y - p_res.y, 2)) > (
    SELECT MIN(SQRT(POW(pv.x - p_res.x, 2) + POW(pv.y - p_res.y, 2)))
    FROM VOTING_CENTER v2
    JOIN PLACE pv ON v2.place_id = pv.place_id
);

-- B.9:

DELIMITER //
CREATE FUNCTION GetClosestCenter(folk_pin CHAR(16), given_date DATE)
RETURNS CHAR(4)
DETERMINISTIC
BEGIN
    DECLARE closest_center CHAR(4);

    SELECT vc.acronym
    INTO closest_center
    FROM RESIDENCE r
    JOIN PLACE pr ON r.place_id = pr.place_id
    JOIN VOTING_CENTER vc ON 1=1
    JOIN PLACE pv ON vc.place_id = pv.place_id
    JOIN OPERATING_PERIOD op ON op.center_id = vc.place_id
    WHERE r.place_id IN (SELECT place_id FROM RESIDENCE WHERE place_id = pr.place_id)
      AND given_date BETWEEN DATE(op.start_dt) AND DATE(op.end_dt)
    ORDER BY SQRT(POW(pv.x - pr.x, 2) + POW(pv.y - pr.y, 2)), vc.acronym
    LIMIT 1;

    RETURN closest_center;
END //
DELIMITER ;

-- B.10:

SET @poll = 'P001';

SELECT vc.acronym AS center,
       SUM(b.choice='YES') AS yes_votes,
       SUM(b.choice='NO') AS no_votes,
       SUM(b.choice='ABSTAIN') AS abstain_votes
FROM BALLOT b
JOIN REGISTRATION r ON b.registration_id = r.registration_id
JOIN VOTING_CENTER vc ON r.center_id = vc.place_id
WHERE b.poll_code = @poll
GROUP BY vc.acronym
ORDER BY vc.acronym ASC;
