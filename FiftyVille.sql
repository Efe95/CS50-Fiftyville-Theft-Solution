-- Insights to look out for and details of the crime
-- Who the thief is
-- Where the thief escaped to
-- Who the thief's accomplice was that helped them escape town
-- Day the crime happened july 28,2021
-- Street it took place humphrey street

-- The description of the crime scene
SELECT id, description
FROM crime_scene_reports csr
WHERE "day" = 28 AND "month" = 7
AND street = 'Humphrey Street';

-- The transcript from witnesses
SELECT id, name, transcript 
FROM interviews i
WHERE "day" = 28 AND "month" = 7;

-- Getting the license plate and id of suspects exiting the bakery
SELECT id, activity, license_plate, "minute"
FROM bakery_security_logs bsl 
WHERE "day" = 28 AND "month" = 7 AND "hour" = 10 
AND activity = 'exit';

-- Names of suspects exiting the bakery after theft
SELECT name, p.id
FROM people p, bakery_security_logs bsl 
WHERE p.license_plate = bsl.license_plate
AND "day" = 28 AND "month" = 7 AND "hour" = 10
AND "minute" BETWEEN 15 AND 25 AND activity = 'exit';

-- Looking through atm transactions done on the day of the theft to narrow down suspects
SELECT id, account_number, transaction_type
FROM atm_transactions at2
WHERE "month" = 7 AND "day" = 28
AND atm_location = 'Leggett Street';

--Matching suspect who exited the bakery after theft to 
-- The people who used atm_transactions on that day
SELECT name
FROM people p, bakery_security_logs bsl 
WHERE p.license_plate = bsl.license_plate
AND "day" = 28 AND "month" = 7 AND "hour" = 10
AND "minute" BETWEEN 15 AND 25 AND activity = 'exit'
AND p.id IN 
(
SELECT person_id
FROM bank_accounts ba, atm_transactions at2
WHERE ba.account_number = at2.account_number 
AND "month" = 7 AND "day" = 28
AND atm_location = 'Leggett Street' 
AND transaction_type = 'withdraw'
);

--looking for suspect who 
--made a call for less than a minute
-- and appeared on bakery_security_logs carpark exit
--and made withdrawal at leggett street 
-- and booked an early flight out of fiftyville
SELECT name
FROM people p, phone_calls pc
WHERE p.phone_number = pc.caller
AND "month" = 7 AND "day" = 28 AND "year" = 2021
AND duration < 60 AND pc.caller IN
(
SELECT p.phone_number
FROM people p, bakery_security_logs bsl 
WHERE p.license_plate = bsl.license_plate
AND "day" = 28 AND "month" = 7 AND "year" = 2021 AND "hour" = 10
AND "minute" BETWEEN 15 AND 25 AND activity = 'exit'
AND p.id IN 
(
SELECT person_id
FROM bank_accounts ba, atm_transactions at2
WHERE ba.account_number = at2.account_number 
AND "month" = 7 AND "day" = 28 AND "year" = 2021
AND atm_location = 'Leggett Street' 
AND transaction_type = 'withdraw'
)) INTERSECT 
SELECT name 
FROM people p2, passengers p 
WHERE p2.passport_number = p.passport_number
AND flight_id IN
(
SELECT id
FROM flights f 
WHERE "year"= 2021 AND "day" = 29 AND "month"= 7 
AND origin_airport_id IN
(
SELECT id 
FROM airports a WHERE city = 'Fiftyville')
ORDER BY "hour", "minute"
LIMIT 1
); --thief found and his name is bruce

--finding name of accomplice who recieved 
--the call made from the thief
-- for less than 1 minute
SELECT name 
FROM people p2 
WHERE phone_number =
(
SELECT receiver
FROM phone_calls pc
WHERE duration <60 AND caller =
(
SELECT phone_number 
FROM people p 
WHERE name = 'Bruce'
));
--accomplice found name Robin

--city they escaped to from passport number 
--used for the flight 
SELECT full_name, city
FROM airports a
WHERE a.id IN 
(
SELECT destination_airport_id
FROM flights f, passengers p, people p2
WHERE f.id = p.flight_id
AND p.passport_number = p2.passport_number
AND "month" = 7 AND "day" = 29 AND name = 'Bruce'
);
--the thief escaped to new york city, laguardia airport





























