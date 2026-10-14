USE wonderland_elections_db;

-- Ensuring serializability:


SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET @registration_id = 1;
SET @poll_code = 'P001';
SET @choice = 'YES';
SET @cast_time = '2025-11-15 09:50:00';

-- Beginning the transaction:

START TRANSACTION;

-- Make sure that it is valid and exists:

SELECT COUNT(*) AS valid_registration
FROM REGISTRATION
WHERE registration_id = @registration_id
  AND voting_date <= CURDATE()
FOR UPDATE;

-- Make sure that the voter hasnt already voted in this same poll:

SELECT COUNT(*) AS existing_vote
FROM BALLOT
WHERE registration_id = @registration_id
  AND poll_code = @poll_code
FOR UPDATE;

-- Only insert if both of the checks pass:

INSERT INTO BALLOT (registration_id, poll_code, choice, cast_dt)
SELECT @registration_id, @poll_code, @choice, @cast_time
FROM REGISTRATION
WHERE registration_id = @registration_id
  AND voting_date <= CURDATE()
  AND NOT EXISTS (
      SELECT 1 FROM BALLOT WHERE registration_id = @registration_id AND poll_code = @poll_code
  );
  
-- Commit the transaction if it is successfull:

COMMIT;

-- Verifying the result:

SELECT * FROM BALLOT WHERE registration_id = @registration_id AND poll_code = @poll_code;
  
