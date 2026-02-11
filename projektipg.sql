

-- =========================
-- 1️⃣ Airlines
-- =========================
CREATE TABLE IF NOT EXISTS Airlines (
    AirlineID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE,
    Country VARCHAR(50) NOT NULL
);

INSERT INTO Airlines (Name, Country)
VALUES 
('SkyAir', 'Germany'),
('FlyKosova', 'Kosovo'),
('BlueWings', 'USA'),
('AirGlobal', 'UK'),
('EuroFly', 'France')
ON CONFLICT (Name) DO NOTHING;

-- =========================
-- 2️⃣ Airports
-- =========================
CREATE TABLE IF NOT EXISTS Airports (
    AirportID SERIAL PRIMARY KEY,
    Code CHAR(4) UNIQUE NOT NULL,
    City VARCHAR(50),
    Country VARCHAR(50)
);

INSERT INTO Airports (Code, City, Country)
VALUES
('PRN','Prishtina','Kosovo'),
('FRA','Frankfurt','Germany'),
('JFK','New York','USA'),
('LHR','London','UK'),
('CDG','Paris','France'),
('BER','Berlin','Germany'),
('VIE','Vienna','Austria'),
('IST','Istanbul','Turkey'),
('MXP','Milan','Italy'),
('DUB','Dublin','Ireland')
ON CONFLICT (Code) DO NOTHING;

-- =========================
-- 3️⃣ Aircrafts
-- =========================
CREATE TABLE IF NOT EXISTS Aircrafts (
    AircraftID SERIAL PRIMARY KEY,
    Model VARCHAR(50),
    Capacity INT CHECK (Capacity > 0)
);

INSERT INTO Aircrafts (Model, Capacity)
VALUES
('Boeing 737',180),
('Airbus A320',160),
('Boeing 777',300),
('Airbus A330',250),
('Embraer 190',100)
ON CONFLICT (Model) DO NOTHING;

-- =========================
-- 4️⃣ Pilots
-- =========================
CREATE TABLE IF NOT EXISTS Pilots (
    PilotID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    LicenseNumber VARCHAR(50) UNIQUE
);

INSERT INTO Pilots (Name, LicenseNumber)
VALUES
('John Smith','LIC123'),
('Anna Brown','LIC456'),
('Michael Johnson','LIC789'),
('Laura Davis','LIC321'),
('Peter Wilson','LIC654')
ON CONFLICT (LicenseNumber) DO NOTHING;

-- =========================
-- 5️⃣ Passengers
-- =========================
CREATE TABLE IF NOT EXISTS Passengers (
    PassengerID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100) UNIQUE
);

INSERT INTO Passengers (Name, Email)
VALUES
('Albina Krasniqi','albina@email.com'),
('Arben Hoxha','arben@email.com'),
('Blerim Selmani','blerim@email.com'),
('Drita Berisha','drita@email.com')
ON CONFLICT (Email) DO NOTHING;

-- =========================
-- 6️⃣ Flights
-- =========================
CREATE TABLE IF NOT EXISTS Flights (
    FlightID SERIAL PRIMARY KEY,
    AirlineID INT REFERENCES Airlines(AirlineID),
    AircraftID INT REFERENCES Aircrafts(AircraftID),
    FromAirport INT REFERENCES Airports(AirportID),
    ToAirport INT REFERENCES Airports(AirportID),
    DepartureTime TIMESTAMP,
    ArrivalTime TIMESTAMP,
    CHECK (ArrivalTime > DepartureTime)
);

INSERT INTO Flights (AirlineID, AircraftID, FromAirport, ToAirport, DepartureTime, ArrivalTime)
VALUES
(1,1,1,1,'2026-02-01 08:00','2026-02-01 10:00'),
(1,1,1,2,'2026-02-01 08:00','2026-02-01 10:00'),
(2,2,2,8,'2026-02-01 09:00','2026-02-01 11:30'),
(1,2,8,9,'2026-02-01 12:00','2026-02-01 18:00'),
(2,1,9,10,'2026-02-02 07:00','2026-02-02 09:00')
ON CONFLICT DO NOTHING;

-- =========================
-- 7️⃣ Bookings
-- =========================
CREATE TABLE IF NOT EXISTS Bookings (
    PassengerID INT REFERENCES Passengers(PassengerID),
    FlightID INT REFERENCES Flights(FlightID),
    SeatNumber VARCHAR(5),
    PRIMARY KEY (PassengerID, FlightID)
);

INSERT INTO Bookings (PassengerID, FlightID, SeatNumber)
VALUES
(1,21,'1A'),
(2,139,'1B'),
(5,140,'2A'),
(6,141,'2B'),
(7,142,'3A')
ON CONFLICT DO NOTHING;

-- =========================
-- 8️⃣ FlightPilots
-- =========================
CREATE TABLE IF NOT EXISTS FlightPilots (
    PilotID INT REFERENCES Pilots(PilotID),
    FlightID INT REFERENCES Flights(FlightID),
    PRIMARY KEY (PilotID, FlightID)
);

INSERT INTO FlightPilots (PilotID, FlightID)
VALUES
(7,21),(8,21),
(9,139),(10,140)
ON CONFLICT DO NOTHING;

-- =========================
-- 9️⃣ Luggage
-- =========================
CREATE TABLE IF NOT EXISTS Luggage (
    LuggageID SERIAL PRIMARY KEY,
    PassengerID INT REFERENCES Passengers(PassengerID),
    Weight DECIMAL(5,2) CHECK (Weight <= 32)
);

INSERT INTO Luggage (PassengerID, Weight)
VALUES
(1,20.5),(2,18.0),(5,25.0),(6,22.0)
ON CONFLICT DO NOTHING;

-- =========================
-- 10️⃣ Payments
-- =========================
CREATE TABLE IF NOT EXISTS Payments (
    PaymentID SERIAL PRIMARY KEY,
    PassengerID INT REFERENCES Passengers(PassengerID),
    Amount DECIMAL(10,2) CHECK (Amount > 0),
    Method VARCHAR(20)
);

INSERT INTO Payments (PassengerID, Amount, Method)
VALUES
(1,150.00,'Credit Card'),
(2,150.00,'Cash'),
(5,300.00,'Credit Card'),
(6,300.00,'Credit Card')
ON CONFLICT DO NOTHING;
