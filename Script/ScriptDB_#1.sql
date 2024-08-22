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

