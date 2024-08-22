CREATE DATABASE Aeropuerto;
USE Aeropuerto;


CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    DateOfBirth DATE NOT NULL,
    Name VARCHAR(100),
    -- FFCNumber INT NULL,  
    -- FOREIGN KEY (FFCNumber) REFERENCES FrequentFlyerCard(FFCNumber)
);

CREATE TABLE FrequentFlyerCard (
    FFCNumber INT PRIMARY KEY,
    Miles INT, -- Miles Decimal(10, 2) 
    MealCode VARCHAR(50),
	CustomerID INT,
	FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Ticket (
    TicketID INT PRIMARY KEY,
    TicketingCode VARCHAR(50) UNIQUE,
    Number INT,
    CustomerID INT,  
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Airport (
	AirportID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL
);

CREATE TABLE PlaneModel (
    PlaneModelID INT PRIMARY KEY,
    Description VARCHAR(100),
    Graphic VARCHAR(50)
);

CREATE TABLE FlightNumber (
    FlightNumberID INT PRIMARY KEY,
    DepartureTime TIME, --DATETIME
    Description VARCHAR(100),
    Type VARCHAR(50),
    Airline VARCHAR(50) NOT NULL,
    StartAirport INT NOT NULL,  
    GoalAirport INT NOT NULL,
	PlaneModelID INT,
    FOREIGN KEY (StartAirport) REFERENCES Airport(AirportID),
    FOREIGN KEY (GoalAirport) REFERENCES Airport(AirportID),
	FOREIGN KEY (PlaneModelID) REFERENCES PlaneModel(PlaneModelID)
);

CREATE TABLE Flight (
    FlightID INT PRIMARY KEY, 
    BoardingTime TIME NOT NULL, --DATETIME
    FlightDate DATE NOT NULL,
    Gate VARCHAR(50),
    CheckInCounter VARCHAR(50),
	FlightNumberID INT,
    FOREIGN KEY (FlightNumberID) REFERENCES FlightNumber(FlightNumberID)
);

CREATE TABLE Airplane (
    RegistrationNumber INT PRIMARY KEY,
    BeginOperation DATE,
    Status VARCHAR(50),
    PlaneModelID INT,  
    FOREIGN KEY (PlaneModelID) REFERENCES PlaneModel(PlaneModelID)
);

CREATE TABLE Seat (
    SeatID INT PRIMARY KEY,
    Size VARCHAR(50),
    Number INT NOT NULL,
    Location VARCHAR(100),
    PlaneModelID INT,  
    FOREIGN KEY (PlaneModelID) REFERENCES PlaneModel(PlaneModelID)
);

CREATE TABLE Coupon (
    CouponID INT PRIMARY KEY,
    DateOfRedemption DATE NOT NULL,
    Class VARCHAR(50),
    Standby BIT,
    MealCode VARCHAR(50),
    TicketID INT NOT NULL,
	FlightID INT,
    FOREIGN KEY (TicketID) REFERENCES Ticket(TicketID),
	FOREIGN KEY (FlightID) REFERENCES Flight(FlightID)
);

CREATE TABLE PiecesOfLuggage (
    Number INT PRIMARY KEY,
    Weight DECIMAL(5,2),
    CouponID INT,  
    FOREIGN KEY (CouponID) REFERENCES Coupon(CouponID)
);

CREATE TABLE AvailableSeat (
    AvailableSeatID INT PRIMARY KEY,
    FlightID INT, 
    SeatID INT,  
	CouponID INT,  
    FOREIGN KEY (FlightID) REFERENCES Flight(FlightID),
    FOREIGN KEY (SeatID) REFERENCES Seat(SeatID),
	FOREIGN KEY (CouponID) REFERENCES Coupon(CouponID)
);

---------------------------------------------insertar datos----------------------

------------------------------------#1-----------------------

INSERT INTO Customer (CustomerID, DateOfBirth, Name)
VALUES 
(1, '1984-05-14', 'John Smith'),
(2, '1972-11-23', 'Jane Doe'),
(3, '1990-07-07', 'Michael Johnson'),
(4, '1968-03-30', 'Emily Davis'),
(5, '2001-09-12', 'David Wilson'),
(6, '1987-12-15', 'Laura Brown'),
(7, '1975-06-22', 'James Taylor'),
(8, '1995-10-03', 'Jessica Lee'),
(9, '1982-08-19', 'Robert Harris'),
(10, '1978-04-25', 'Linda Clark'),
(11, '1993-01-09', 'Christopher Walker'),
(12, '1989-02-28', 'Patricia Hall'),
(13, '1965-07-14', 'Matthew Allen'),
(14, '1985-05-05', 'Jennifer Wright'),
(15, '1970-09-18', 'Joshua King'),
(16, '1992-11-11', 'Sarah Lewis'),
(17, '1976-03-21', 'Brian Young'),
(18, '1983-12-07', 'Karen Martinez'),
(19, '1991-06-02', 'Richard Scott'),
(20, '1988-08-26', 'Ashley Green');

------------------------------------#2-----------------------

INSERT INTO FrequentFlyerCard (FFCNumber, Miles, MealCode, CustomerID)
VALUES 
(1, 15000, 'VGML', 1),  -- John Smith
(2, 23000, 'HNML', 2),  -- Jane Doe
(3, 8000,  'LCML', 3),  -- Michael Johnson
(4, 12000, 'CHML', 4),  -- Emily Davis
(5, 3000,  'BLML', 5),  -- David Wilson
(6, 45000, 'VGML', 6),  -- Laura Brown
(7, 21000, 'HNML', 7),  -- James Taylor
(8, 5000,  'LCML', 8),  -- Jessica Lee
(9, 17000, 'VGML', 9),  -- Robert Harris
(10, 60000, 'CHML', 10), -- Linda Clark
(11, 22000, 'BLML', 11), -- Christopher Walker
(12, 10000, 'VGML', 12), -- Patricia Hall
(13, 7000,  'HNML', 13), -- Matthew Allen
(14, 35000, 'LCML', 14), -- Jennifer Wright
(15, 9000,  'CHML', 15), -- Joshua King
(16, 28000, 'BLML', 16), -- Sarah Lewis
(17, 14000, 'VGML', 17), -- Brian Young
(18, 26000, 'HNML', 18), -- Karen Martinez
(19, 2000,  'LCML', 19), -- Richard Scott
(20, 38000, 'CHML', 20); -- Ashley Green

------------------------------------#3-----------------------

INSERT INTO Ticket (TicketID, TicketingCode, Number, CustomerID)
VALUES 
(1, 'TCKT123456', 1, 1),  -- John Smith
(2, 'TCKT654321', 2, 2),  -- Jane Doe
(3, 'TCKT112233', 3, 3),  -- Michael Johnson
(4, 'TCKT332211', 4, 4),  -- Emily Davis
(5, 'TCKT445566', 5, 5),  -- David Wilson
(6, 'TCKT556644', 6, 6),  -- Laura Brown
(7, 'TCKT778899', 7, 7),  -- James Taylor
(8, 'TCKT998877', 8, 8),  -- Jessica Lee
(9, 'TCKT223344', 9, 9),  -- Robert Harris
(10, 'TCKT443322', 10, 10), -- Linda Clark
(11, 'TCKT667788', 11, 11), -- Christopher Walker
(12, 'TCKT887766', 12, 12), -- Patricia Hall
(13, 'TCKT334455', 13, 13), -- Matthew Allen
(14, 'TCKT554433', 14, 14), -- Jennifer Wright
(15, 'TCKT669988', 15, 15), -- Joshua King
(16, 'TCKT889966', 16, 16), -- Sarah Lewis
(17, 'TCKT445577', 17, 17), -- Brian Young
(18, 'TCKT775544', 18, 18), -- Karen Martinez
(19, 'TCKT556677', 19, 19), -- Richard Scott
(20, 'TCKT776655', 20, 20); -- Ashley Green


------------------------------------#4-----------------------

INSERT INTO Airport (AirportID, Name)
VALUES 
(1, 'John F. Kennedy International Airport'),  -- New York
(2, 'Los Angeles International Airport'),      -- Los Angeles
(3, 'Hare International Airport'),          -- Chicago
(4, 'Dallas/Fort Worth International Airport'),-- Dallas/Fort Worth
(5, 'Denver International Airport'),           -- Denver
(6, 'San Francisco International Airport'),    -- San Francisco
(7, 'Seattle-Tacoma International Airport'),   -- Seattle
(8, 'Miami International Airport'),            -- Miami
(9, 'Orlando International Airport'),          -- Orlando
(10, 'Boston Logan International Airport'),    -- Boston
(11, 'Hartsfield-Jackson Atlanta International Airport'), -- Atlanta
(12, 'McCarran International Airport'),        -- Las Vegas
(13, 'Charlotte Douglas International Airport'),-- Charlotte
(14, 'Phoenix Sky Harbor International Airport'),-- Phoenix
(15, 'George Bush Intercontinental Airport'),  -- Houston
(16, 'Philadelphia International Airport'),    -- Philadelphia
(17, 'Minneapolis-Saint Paul International Airport'),-- Minneapolis
(18, 'Detroit Metropolitan Airport'),          -- Detroit
(19, 'Salt Lake City International Airport'),  -- Salt Lake City
(20, 'Washington Dulles International Airport');-- Washington, D.C.

------------------------------------#5-----------------------

INSERT INTO PlaneModel (PlaneModelID, Description, Graphic)
VALUES 
(1, 'Boeing 737', '737.png'),
(2, 'Airbus A320', 'A320.png'),
(3, 'Boeing 777', '777.png'),
(4, 'Airbus A380', 'A380.png'),
(5, 'Boeing 787 Dreamliner', '787.png'),
(6, 'Airbus A350', 'A350.png'),
(7, 'Embraer E190', 'E190.png'),
(8, 'Bombardier CRJ900', 'CRJ900.png'),
(9, 'Boeing 767', '767.png'),
(10, 'Airbus A330', 'A330.png'),
(11, 'Boeing 747', '747.png'),
(12, 'Airbus A340', 'A340.png'),
(13, 'Boeing 757', '757.png'),
(14, 'Airbus A321', 'A321.png'),
(15, 'Boeing 727', '727.png'),
(16, 'Airbus A310', 'A310.png'),
(17, 'Boeing 717', '717.png'),
(18, 'Airbus A220', 'A220.png'),
(19, 'Boeing 737 MAX', '737MAX.png'),
(20, 'Airbus A330neo', 'A330neo.png');

------------------------------------#6-----------------------

INSERT INTO FlightNumber (FlightNumberID, DepartureTime, Description, Type, Airline, StartAirport, GoalAirport, PlaneModelID)
VALUES 
(1, '08:30', 'Morning Flight to Los Angeles', 'Domestic', 'American Airlines', 1, 2, 1),  -- JFK to LAX, Boeing 737
(2, '12:15', 'Midday Flight to Chicago', 'Domestic', 'United Airlines', 2, 3, 2),         -- LAX to ORD, Airbus A320
(3, '15:45', 'Afternoon Flight to Dallas', 'Domestic', 'Delta Airlines', 3, 4, 3),        -- ORD to DFW, Boeing 777
(4, '18:00', 'Evening Flight to Denver', 'Domestic', 'Southwest Airlines', 4, 5, 4),      -- DFW to DEN, Airbus A380
(5, '20:00', 'Night Flight to San Francisco', 'Domestic', 'Alaska Airlines', 5, 6, 5),    -- DEN to SFO, Boeing 787 Dreamliner
(6, '06:30', 'Early Morning Flight to Seattle', 'Domestic', 'JetBlue Airways', 6, 7, 6),  -- SFO to SEA, Airbus A350
(7, '09:00', 'Morning Flight to Miami', 'Domestic', 'Spirit Airlines', 7, 8, 7),          -- SEA to MIA, Embraer E190
(8, '11:30', 'Midday Flight to Orlando', 'Domestic', 'Frontier Airlines', 8, 9, 8),       -- MIA to MCO, Bombardier CRJ900
(9, '14:00', 'Afternoon Flight to Boston', 'Domestic', 'American Airlines', 9, 10, 9),    -- MCO to BOS, Boeing 767
(10, '16:30', 'Evening Flight to Atlanta', 'Domestic', 'United Airlines', 10, 11, 10),    -- BOS to ATL, Airbus A330
(11, '19:00', 'Night Flight to Las Vegas', 'Domestic', 'Delta Airlines', 11, 12, 11),     -- ATL to LAS, Boeing 747
(12, '22:00', 'Late Night Flight to Charlotte', 'Domestic', 'Southwest Airlines', 12, 13, 12), -- LAS to CLT, Airbus A340
(13, '07:00', 'Morning Flight to Phoenix', 'Domestic', 'American Airlines', 13, 14, 13),  -- CLT to PHX, Boeing 757
(14, '09:30', 'Midday Flight to Houston', 'Domestic', 'United Airlines', 14, 15, 14),     -- PHX to IAH, Airbus A321
(15, '12:00', 'Afternoon Flight to Philadelphia', 'Domestic', 'Delta Airlines', 15, 16, 15), -- IAH to PHL, Boeing 727
(16, '14:30', 'Evening Flight to Minneapolis', 'Domestic', 'Southwest Airlines', 16, 17, 16), -- PHL to MSP, Airbus A310
(17, '17:00', 'Night Flight to Detroit', 'Domestic', 'JetBlue Airways', 17, 18, 17),      -- MSP to DTW, Boeing 717
(18, '19:30', 'Late Night Flight to Salt Lake City', 'Domestic', 'Spirit Airlines', 18, 19, 18), -- DTW to SLC, Airbus A220
(19, '21:45', 'Red-eye Flight to Washington D.C.', 'Domestic', 'Frontier Airlines', 19, 20, 19), -- SLC to IAD, Boeing 737 MAX
(20, '05:00', 'Early Morning Flight to New York', 'Domestic', 'American Airlines', 20, 1, 20); -- IAD to JFK, Airbus A330neo

------------------------------------#7-----------------------

INSERT INTO Flight (FlightID, BoardingTime, FlightDate, Gate, CheckInCounter, FlightNumberID)
VALUES 
(1, '08:00', '2024-08-15', 'A1', 'C12', 1),  -- Morning Flight to Los Angeles
(2, '11:45', '2024-08-15', 'B2', 'D14', 2),  -- Midday Flight to Chicago
(3, '15:15', '2024-08-15', 'C3', 'E16', 3),  -- Afternoon Flight to Dallas
(4, '17:30', '2024-08-15', 'D4', 'F18', 4),  -- Evening Flight to Denver
(5, '19:30', '2024-08-15', 'E5', 'G20', 5),  -- Night Flight to San Francisco
(6, '06:00', '2024-08-16', 'F6', 'H22', 6),  -- Early Morning Flight to Seattle
(7, '08:30', '2024-08-16', 'G7', 'I24', 7),  -- Morning Flight to Miami
(8, '11:00', '2024-08-16', 'H8', 'J26', 8),  -- Midday Flight to Orlando
(9, '13:30', '2024-08-16', 'I9', 'K28', 9),  -- Afternoon Flight to Boston
(10, '16:00', '2024-08-16', 'J10', 'L30', 10), -- Evening Flight to Atlanta
(11, '18:30', '2024-08-16', 'K11', 'M32', 11), -- Night Flight to Las Vegas
(12, '21:30', '2024-08-16', 'L12', 'N34', 12), -- Late Night Flight to Charlotte
(13, '06:30', '2024-08-17', 'M13', 'O36', 13), -- Morning Flight to Phoenix
(14, '09:00', '2024-08-17', 'N14', 'P38', 14), -- Midday Flight to Houston
(15, '11:30', '2024-08-17', 'O15', 'Q40', 15), -- Afternoon Flight to Philadelphia
(16, '14:00', '2024-08-17', 'P16', 'R42', 16), -- Evening Flight to Minneapolis
(17, '16:30', '2024-08-17', 'Q17', 'S44', 17), -- Night Flight to Detroit
(18, '19:00', '2024-08-17', 'R18', 'T46', 18), -- Late Night Flight to Salt Lake City
(19, '21:15', '2024-08-17', 'S19', 'U48', 19), -- Red-eye Flight to Washington D.C.
(20, '04:30', '2024-08-18', 'T20', 'V50', 20); -- Early Morning Flight to New York

------------------------------------#8-----------------------

INSERT INTO Airplane (RegistrationNumber, BeginOperation, Status, PlaneModelID)
VALUES 
(1001, '2022-01-15', 'Active', 1),  -- Boeing 737
(1002, '2021-03-20', 'Active', 2),  -- Airbus A320
(1003, '2020-07-10', 'Active', 3),  -- Boeing 777
(1004, '2019-11-05', 'Active', 4),  -- Airbus A380
(1005, '2018-02-18', 'Active', 5),  -- Boeing 787 Dreamliner
(1006, '2017-09-25', 'Active', 6),  -- Airbus A350
(1007, '2016-05-30', 'Active', 7),  -- Embraer E190
(1008, '2015-08-14', 'Active', 8),  -- Bombardier CRJ900
(1009, '2014-12-21', 'Active', 9),  -- Boeing 767
(1010, '2013-03-03', 'Active', 10), -- Airbus A330
(1011, '2012-06-12', 'Active', 11), -- Boeing 747
(1012, '2011-01-28', 'Active', 12), -- Airbus A340
(1013, '2010-09-16', 'Active', 13), -- Boeing 757
(1014, '2009-04-22', 'Active', 14), -- Airbus A321
(1015, '2008-07-29', 'Active', 15), -- Boeing 727
(1016, '2007-11-19', 'Active', 16), -- Airbus A310
(1017, '2006-10-02', 'Active', 17), -- Boeing 717
(1018, '2005-08-07', 'Active', 18), -- Airbus A220
(1019, '2004-05-14', 'Active', 19), -- Boeing 737 MAX
(1020, '2003-03-11', 'Active', 20); -- Airbus A330neo

------------------------------------#9-----------------------

INSERT INTO Seat (SeatID, Size, Number, Location, PlaneModelID)
VALUES 
(1, 'Standard', 1, 'Front Left', 1),  -- Boeing 737
(2, 'Standard', 2, 'Front Right', 1),
(3, 'Standard', 3, 'Middle Left', 1),
(4, 'Standard', 4, 'Middle Right', 1),
(5, 'Standard', 5, 'Rear Left', 1),
(6, 'Standard', 6, 'Rear Right', 1),
(7, 'Extra Legroom', 1, 'Front Left', 2),  -- Airbus A320
(8, 'Extra Legroom', 2, 'Front Right', 2),
(9, 'Standard', 3, 'Middle Left', 2),
(10, 'Standard', 4, 'Middle Right', 2),
(11, 'Standard', 5, 'Rear Left', 2),
(12, 'Standard', 6, 'Rear Right', 2),
(13, 'Business', 1, 'Front Left', 3),  -- Boeing 777
(14, 'Business', 2, 'Front Right', 3),
(15, 'Standard', 3, 'Middle Left', 3),
(16, 'Standard', 4, 'Middle Right', 3),
(17, 'Standard', 5, 'Rear Left', 3),
(18, 'Standard', 6, 'Rear Right', 3),
(19, 'Economy', 1, 'Front Left', 4),  -- Airbus A380
(20, 'Economy', 2, 'Front Right', 4);

------------------------------------#10-----------------------

INSERT INTO Coupon (CouponID, DateOfRedemption, Class, Standby, MealCode, TicketID, FlightID)
VALUES 
(1, '2024-08-15', 'Economy', 0, 'Vegan', 1, 1),  -- Ticket 1, Flight 1
(2, '2024-08-15', 'Economy', 0, 'Vegetarian', 2, 2),  -- Ticket 2, Flight 2
(3, '2024-08-15', 'Business', 0, 'Regular', 3, 3),  -- Ticket 3, Flight 3
(4, '2024-08-15', 'First Class', 0, 'Gluten-Free', 4, 4),  -- Ticket 4, Flight 4
(5, '2024-08-15', 'Economy', 1, 'Vegan', 5, 5),  -- Ticket 5, Flight 5
(6, '2024-08-16', 'Economy', 0, 'Vegetarian', 6, 6),  -- Ticket 6, Flight 6
(7, '2024-08-16', 'Business', 0, 'Regular', 7, 7),  -- Ticket 7, Flight 7
(8, '2024-08-16', 'Economy', 0, 'Gluten-Free', 8, 8),  -- Ticket 8, Flight 8
(9, '2024-08-16', 'First Class', 1, 'Vegan', 9, 9),  -- Ticket 9, Flight 9
(10, '2024-08-16', 'Economy', 0, 'Vegetarian', 10, 10),  -- Ticket 10, Flight 10
(11, '2024-08-16', 'Business', 0, 'Regular', 11, 11),  -- Ticket 11, Flight 11
(12, '2024-08-16', 'Economy', 1, 'Gluten-Free', 12, 12),  -- Ticket 12, Flight 12
(13, '2024-08-17', 'Economy', 0, 'Vegan', 13, 13),  -- Ticket 13, Flight 13
(14, '2024-08-17', 'First Class', 0, 'Vegetarian', 14, 14),  -- Ticket 14, Flight 14
(15, '2024-08-17', 'Business', 1, 'Regular', 15, 15),  -- Ticket 15, Flight 15
(16, '2024-08-17', 'Economy', 0, 'Gluten-Free', 16, 16),  -- Ticket 16, Flight 16
(17, '2024-08-17', 'Economy', 1, 'Vegan', 17, 17),  -- Ticket 17, Flight 17
(18, '2024-08-17', 'Business', 0, 'Vegetarian', 18, 18),  -- Ticket 18, Flight 18
(19, '2024-08-17', 'Economy', 0, 'Regular', 19, 19),  -- Ticket 19, Flight 19
(20, '2024-08-18', 'First Class', 0, 'Gluten-Free', 20, 20);  -- Ticket 20, Flight 20

------------------------------------#11-----------------------
INSERT INTO PiecesOfLuggage (Number, Weight, CouponID)
VALUES 
(1, 23.50, 1),  -- Luggage for Coupon 1
(2, 18.20, 2),  -- Luggage for Coupon 2
(3, 27.75, 3),  -- Luggage for Coupon 3
(4, 22.00, 4),  -- Luggage for Coupon 4
(5, 19.50, 5),  -- Luggage for Coupon 5
(6, 24.30, 6),  -- Luggage for Coupon 6
(7, 20.10, 7),  -- Luggage for Coupon 7
(8, 26.80, 8),  -- Luggage for Coupon 8
(9, 21.00, 9),  -- Luggage for Coupon 9
(10, 17.75, 10),  -- Luggage for Coupon 10
(11, 25.20, 11),  -- Luggage for Coupon 11
(12, 22.50, 12),  -- Luggage for Coupon 12
(13, 18.90, 13),  -- Luggage for Coupon 13
(14, 23.00, 14),  -- Luggage for Coupon 14
(15, 19.80, 15),  -- Luggage for Coupon 15
(16, 24.75, 16),  -- Luggage for Coupon 16
(17, 21.30, 17),  -- Luggage for Coupon 17
(18, 26.50, 18),  -- Luggage for Coupon 18
(19, 20.00, 19),  -- Luggage for Coupon 19
(20, 22.75, 20);  -- Luggage for Coupon 20


------------------------------------#12-----------------------
INSERT INTO AvailableSeat (AvailableSeatID, FlightID, SeatID, CouponID)
VALUES 
(1, 1, 1, 1),   -- Flight 1, Seat 1, Coupon 1
(2, 2, 2, 2),   -- Flight 2, Seat 2, Coupon 2
(3, 3, 3, 3),   -- Flight 3, Seat 3, Coupon 3
(4, 4, 4, 4),   -- Flight 4, Seat 4, Coupon 4
(5, 5, 5, 5),   -- Flight 5, Seat 5, Coupon 5
(6, 6, 6, 6),   -- Flight 6, Seat 6, Coupon 6
(7, 7, 7, 7),   -- Flight 7, Seat 7, Coupon 7
(8, 8, 8, 8),   -- Flight 8, Seat 8, Coupon 8
(9, 9, 9, 9),   -- Flight 9, Seat 9, Coupon 9
(10, 10, 10, 10), -- Flight 10, Seat 10, Coupon 10
(11, 11, 11, 11), -- Flight 11, Seat 11, Coupon 11
(12, 12, 12, 12), -- Flight 12, Seat 12, Coupon 12
(13, 13, 13, 13), -- Flight 13, Seat 13, Coupon 13
(14, 14, 14, 14), -- Flight 14, Seat 14, Coupon 14
(15, 15, 15, 15), -- Flight 15, Seat 15, Coupon 15
(16, 16, 16, 16), -- Flight 16, Seat 16, Coupon 16
(17, 17, 17, 17), -- Flight 17, Seat 17, Coupon 17
(18, 18, 18, 18), -- Flight 18, Seat 18, Coupon 18
(19, 19, 19, 19), -- Flight 19, Seat 19, Coupon 19
(20, 20, 20, 20); -- Flight 20, Seat 20, Coupon 20

----------------------------------------------------------
Select * From Customer                --1
Select * From FrequentFlyerCard       --2
Select * From Ticket                  --3
Select * From Airport                 --4
Select * From PlaneModel              --5
Select * From FlightNumber            --6
Select * From Flight                  --7
Select * From Airplane                --8
Select * From Seat                    --9
Select * From Coupon                  --10
Select * From PiecesOfLuggage         --11
Select * From AvailableSeat           --12




-------------------------------------------------Consultas-----------------------
