
SELECT f.FlightID,
       a1.City AS FromCity,
       a2.City AS ToCity,
       f.DepartureTime,
       f.ArrivalTime
FROM Flights f
JOIN Airports a1 ON f.FromAirport = a1.AirportID
JOIN Airports a2 ON f.ToAirport = a2.AirportID;


SELECT p.Name AS Passenger,
       f.FlightID,
       f.DepartureTime
FROM Bookings b
JOIN Passengers p ON b.PassengerID = p.PassengerID
JOIN Flights f ON b.FlightID = f.FlightID;

SELECT f.FlightID,
       p.Name AS PilotName
FROM FlightPilots fp
JOIN Pilots p ON fp.PilotID = p.PilotID
JOIN Flights f ON fp.FlightID = f.FlightID;

SELECT FlightID, COUNT(*) AS TotalPassengers
FROM Bookings
GROUP BY FlightID;

SELECT p.Name,
       SUM(l.Weight) AS TotalLuggageWeight
FROM Luggage l
JOIN Passengers p ON l.PassengerID = p.PassengerID
GROUP BY p.Name;

SELECT AVG(Capacity) AS AverageCapacity
FROM Aircrafts;

SELECT a.Name,
       COUNT(f.FlightID) AS TotalFlights
FROM Airlines a
LEFT JOIN Flights f ON a.AirlineID = f.AirlineID
GROUP BY a.Name;

SELECT f.*
FROM Flights f
JOIN Airports a ON f.FromAirport = a.AirportID
WHERE a.City = 'Prishtina';


SELECT p.Name, pay.Amount
FROM Payments pay
JOIN Passengers p ON pay.PassengerID = p.PassengerID
WHERE pay.Amount > 200;


SELECT Name
FROM Passengers
WHERE PassengerID IN (
    SELECT PassengerID FROM Bookings
);


TRIGGER (SHUMË I RËNDËSISHËM)

CREATE OR REPLACE FUNCTION check_aircraft_capacity()
RETURNS TRIGGER AS $$
DECLARE
    booked_seats INT;
    max_capacity INT;
BEGIN
    SELECT COUNT(*) INTO booked_seats
    FROM Bookings
    WHERE FlightID = NEW.FlightID;

    SELECT a.Capacity INTO max_capacity
    FROM Flights f
    JOIN Aircrafts a ON f.AircraftID = a.AircraftID
    WHERE f.FlightID = NEW.FlightID;

    IF booked_seats >= max_capacity THEN
        RAISE EXCEPTION 'Aircraft is full!';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_check_capacity
BEFORE INSERT ON Bookings
FOR EACH ROW
EXECUTE FUNCTION check_aircraft_capacity();


SELECT a.Capacity
FROM Flights f
JOIN Aircrafts a ON f.AircraftID = a.AircraftID
WHERE f.FlightID = 2;



INSERT INTO Bookings VALUES (1,21,'1A');
INSERT INTO Bookings VALUES (2,21,'1B');
INSERT INTO Bookings VALUES (3,21,'2A');
ON CONFLICT (Code) DO NOTHING;

ALTER TABLE Bookings
ADD CONSTRAINT unique_seat_per_flight
UNIQUE (FlightID, SeatNumber);



