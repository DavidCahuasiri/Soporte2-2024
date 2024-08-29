-- Verificar si la base de datos ya existe
IF DB_ID('Aeropuerto') IS NULL
BEGIN
    -- Crear la base de datos
    EXEC('CREATE DATABASE Aeropuerto');
END
GO

-- Uso de la base de datos recién creada
USE Aeropuerto;
GO



-- #1 Tabla de País
CREATE TABLE Country (
    CountryID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE
);
GO

-- #2 Tabla de Ciudad
CREATE TABLE City (
    CityID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    CountryID INT,
    FOREIGN KEY (CountryID) REFERENCES Country(CountryID) ON DELETE SET NULL
);
GO

-- #3 Tabla de Categoría de Cliente
CREATE TABLE CustomerCategory (
    CustomerCategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL UNIQUE
);
GO

-- #4 Tabla de Cliente con referencia a Categoría
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    DateOfBirth DATE NOT NULL,
    Name VARCHAR(100) NOT NULL,
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES CustomerCategory(CustomerCategoryID) ON DELETE SET NULL
);
GO

-- Crear índice en el atributo 'Name' de Customer
CREATE INDEX IDX_Customer_Name ON Customer(Name);
GO

-- #5 Tabla de Documento (Pasaporte)
CREATE TABLE Document (
    DocumentID INT PRIMARY KEY,
    PassportNumber VARCHAR(50) UNIQUE NOT NULL,
    IssueDate DATE,
    ExpiryDate DATE,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON DELETE SET NULL
);
GO

-- #6 Tabla de Tarjeta de Viajero Frecuente
CREATE TABLE FrequentFlyerCard (
    FFCNumber INT PRIMARY KEY,
    Miles DECIMAL(10, 2),
    MealCode VARCHAR(50),
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON DELETE SET NULL
);
GO

-- Crear índice en el atributo 'Miles' de FrequentFlyerCard
CREATE INDEX IDX_FrequentFlyerCard_Miles ON FrequentFlyerCard(Miles);
GO

-- #7 Tabla de Categoría de Ticket
CREATE TABLE TicketCategory (
    TicketCategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL UNIQUE
);
GO

-- #8 Tabla de Ticket con referencia a Categoría
CREATE TABLE Ticket (
    TicketID INT PRIMARY KEY,
    TicketingCode VARCHAR(50) UNIQUE NOT NULL,
    Number INT NOT NULL,
    CategoryID INT,
    CustomerID INT,
    FOREIGN KEY (CategoryID) REFERENCES TicketCategory(TicketCategoryID) ON DELETE SET NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON DELETE SET NULL
);
GO

-- Crear índice en el atributo 'TicketingCode' de Ticket
CREATE INDEX IDX_Ticket_TicketingCode ON Ticket(TicketingCode);
GO

-- #9 Tabla de Aeropuerto con relación a Ciudad
CREATE TABLE Airport (
    AirportID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    CityID INT,
    FOREIGN KEY (CityID) REFERENCES City(CityID) ON DELETE SET NULL
);
GO

-- Crear índice en el atributo 'Name' de Airport
CREATE INDEX IDX_Airport_Name ON Airport(Name);
GO

-- #10 Tabla de Modelo de Avión
CREATE TABLE PlaneModel (
    PlaneModelID INT PRIMARY KEY,
    Description VARCHAR(100),
    Graphic VARCHAR(50)
);
GO

-- #11 Tabla de Número de Vuelo
CREATE TABLE FlightNumber (
    FlightNumberID INT PRIMARY KEY,
    DepartureTime TIME,
    Description VARCHAR(100),
    Type VARCHAR(50),
    Airline VARCHAR(50) NOT NULL,
    StartAirport INT NOT NULL,
    GoalAirport INT NOT NULL,
    PlaneModelID INT,
    FOREIGN KEY (StartAirport) REFERENCES Airport(AirportID) ON DELETE NO ACTION,
    FOREIGN KEY (GoalAirport) REFERENCES Airport(AirportID) ON DELETE NO ACTION,
    FOREIGN KEY (PlaneModelID) REFERENCES PlaneModel(PlaneModelID) ON DELETE SET NULL
);
GO

CREATE INDEX IDX_FlightNumber_StartAirport ON FlightNumber(StartAirport);
CREATE INDEX IDX_FlightNumber_GoalAirport ON FlightNumber(GoalAirport);
GO

--#12 Tabla Categoría de vuelo
CREATE TABLE FlightCategory (
    FlightCategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL UNIQUE
);
GO


-- #13 Tabla de Vuelo
CREATE TABLE Flight (
    FlightID INT PRIMARY KEY,
    BoardingTime TIME NOT NULL,
    FlightDate DATE NOT NULL,
    Gate VARCHAR(50),
    CheckInCounter VARCHAR(50),
    FlightNumberID INT,
	FlightCategoryID INT,
    FOREIGN KEY (FlightNumberID) REFERENCES FlightNumber(FlightNumberID) ON DELETE SET NULL,
	FOREIGN KEY (FlightCategoryID) REFERENCES FlightCategory(FlightCategoryID) ON DELETE SET NULL
);
GO

-- Crear índice en el atributo 'FlightDate' de Flight
CREATE INDEX IDX_Flight_FlightDate ON Flight(FlightDate);
GO

-- #14 Tabla de Avión
CREATE TABLE Airplane (
    RegistrationNumber INT PRIMARY KEY,
    BeginOperation DATE,
    Status VARCHAR(50),
    PlaneModelID INT,
    FOREIGN KEY (PlaneModelID) REFERENCES PlaneModel(PlaneModelID) ON DELETE SET NULL
);
GO

-- Crear índice en el atributo 'Status' de Airplane
CREATE INDEX IDX_Airplane_Status ON Airplane(Status);
GO

-- #15 Tabla de Asiento
CREATE TABLE Seat (
    SeatID INT PRIMARY KEY,
    Size VARCHAR(50),
    Number INT NOT NULL,
    Location VARCHAR(100),
    PlaneModelID INT,
    FOREIGN KEY (PlaneModelID) REFERENCES PlaneModel(PlaneModelID) ON DELETE SET NULL
);
GO

-- Crear índice en el atributo 'Number' de Seat
CREATE INDEX IDX_Seat_Number ON Seat(Number);
GO

-- #16 Tabla de Cupón
CREATE TABLE Coupon (
    CouponID INT PRIMARY KEY,
    DateOfRedemption DATE NOT NULL,
    Class VARCHAR(50),
    Standby BIT,
    MealCode VARCHAR(50),
    TicketID INT NOT NULL,
    FlightID INT,
    FOREIGN KEY (TicketID) REFERENCES Ticket(TicketID) ON DELETE CASCADE,
    FOREIGN KEY (FlightID) REFERENCES Flight(FlightID) ON DELETE SET NULL
);
GO

-- Crear índice en el atributo 'DateOfRedemption' de Coupon
CREATE INDEX IDX_Coupon_DateOfRedemption ON Coupon(DateOfRedemption);
GO

-- #17 Tabla de Equipaje
CREATE TABLE PiecesOfLuggage (
    Number INT PRIMARY KEY,
    Weight DECIMAL(5,2),
    CouponID INT,
    FOREIGN KEY (CouponID) REFERENCES Coupon(CouponID) ON DELETE CASCADE
);
GO

-- Crear índice en el atributo 'Weight' de PiecesOfLuggage
CREATE INDEX IDX_PiecesOfLuggage_Weight ON PiecesOfLuggage(Weight);
GO

-- #18 Tabla de Asiento Disponible
CREATE TABLE AvailableSeat (
    AvailableSeatID INT PRIMARY KEY,
    FlightID INT,
    SeatID INT,
    CouponID INT,
    FOREIGN KEY (FlightID) REFERENCES Flight(FlightID) ON DELETE CASCADE,
    FOREIGN KEY (SeatID) REFERENCES Seat(SeatID) ON DELETE SET NULL,
    FOREIGN KEY (CouponID) REFERENCES Coupon(CouponID) ON DELETE SET NULL
);
GO

-- Crear índice en el atributo 'FlightID' de AvailableSeat
CREATE INDEX IDX_AvailableSeat_FlightID ON AvailableSeat(FlightID);
GO


---------------------------------------------insertar datos----------------------

------------------------------------#1-----------------------

-- Insertar datos en la tabla Country
INSERT INTO Country (CountryID, Name) VALUES
(1, 'Argentina'),
(2, 'Bolivia'),
(3, 'Chile'),
(4, 'Colombia'),
(5, 'Ecuador'),
(6, 'Perú'),
(7, 'Uruguay'),
(8, 'Paraguay'),
(9, 'Venezuela'),
(10, 'Brasil'),
(11, 'México'),
(12, 'Estados Unidos'),
(13, 'Canadá'),
(14, 'Reino Unido'),
(15, 'Francia'),
(16, 'Alemania'),
(17, 'Italia'),
(18, 'España'),
(19, 'Portugal'),
(20, 'Australia');
GO

------------------------------------#2-----------------------

-- Insertar datos en la tabla City
INSERT INTO City (CityID, Name, CountryID) VALUES
(1, 'Buenos Aires', 1),
(2, 'La Paz', 2),
(3, 'Santiago', 3),
(4, 'Bogotá', 4),
(5, 'Quito', 5),
(6, 'Lima', 6),
(7, 'Montevideo', 7),
(8, 'Asunción', 8),
(9, 'Caracas', 9),
(10, 'São Paulo', 10),
(11, 'Ciudad de México', 11),
(12, 'Nueva York', 12),
(13, 'Toronto', 13),
(14, 'Londres', 14),
(15, 'París', 15),
(16, 'Berlín', 16),
(17, 'Roma', 17),
(18, 'Madrid', 18),
(19, 'Lisboa', 19),
(20, 'Sídney', 20);
GO

------------------------------------#3-----------------------

-- Insertar datos en la tabla CustomerCategory
INSERT INTO CustomerCategory (CustomerCategoryID, CategoryName) VALUES
(1, 'Frecuente'),
(2, 'Ocasional'),
(3, 'VIP'),
(4, 'Nuevo'),
(5, 'Silver'),
(6, 'Gold'),
(7, 'Platinum'),
(8, 'Negocios'),
(9, 'Económico'),
(10, 'Premium'),
(11, 'Business'),
(12, 'Standard'),
(13, 'Elite'),
(14, 'Regular'),
(15, 'Distinguido'),
(16, 'Loyal'),
(17, 'Frequent'),
(18, 'Member'),
(19, 'Adicional'),
(20, 'Convenio');
GO

------------------------------------#4-----------------------
-- Insertar datos en la tabla Customer
INSERT INTO Customer (CustomerID, DateOfBirth, Name, CategoryID) VALUES
(1, '1985-03-15', 'Juan Pérez', 1),
(2, '1990-07-22', 'María Gómez', 2),
(3, '1982-11-05', 'Carlos Rodríguez', 3),
(4, '1975-09-13', 'Ana Martínez', 4),
(5, '1988-12-01', 'Luis Fernández', 5),
(6, '1995-04-30', 'Sofía López', 6),
(7, '1980-02-17', 'José García', 7),
(8, '1992-06-25', 'Elena Torres', 8),
(9, '1984-08-19', 'Pedro Morales', 9),
(10, '1979-10-30', 'Lucía Castro', 10),
(11, '1987-01-14', 'Jorge Romero', 11),
(12, '1991-05-21', 'Claudia Martínez', 12),
(13, '1986-07-09', 'Ricardo Gómez', 13),
(14, '1993-11-11', 'Verónica Ruiz', 14),
(15, '1983-12-28', 'Francisco Moreno', 15),
(16, '1994-08-07', 'Patricia Sánchez', 16),
(17, '1989-03-04', 'Raúl Herrera', 17),
(18, '1981-06-15', 'Carmen Díaz', 18),
(19, '1996-02-20', 'Alberto Peña', 19),
(20, '1978-10-12', 'Mariana Silva', 20);
GO

------------------------------------#5-----------------------

-- Insertar datos en la tabla Document
INSERT INTO Document (DocumentID, PassportNumber, IssueDate, ExpiryDate, CustomerID) VALUES
(1, 'P123456789', '2020-01-15', '2030-01-15', 1),
(2, 'P987654321', '2019-07-22', '2029-07-22', 2),
(3, 'P112233445', '2018-11-10', '2028-11-10', 3),
(4, 'P556677889', '2021-03-12', '2031-03-12', 4),
(5, 'P998877665', '2017-09-25', '2027-09-25', 5),
(6, 'P443322110', '2022-06-30', '2032-06-30', 6),
(7, 'P223344556', '2016-08-15', '2026-08-15', 7),
(8, 'P665544332', '2023-02-20', '2033-02-20', 8),
(9, 'P778899001', '2020-12-01', '2030-12-01', 9),
(10, 'P334455667', '2015-04-14', '2025-04-14', 10),
(11, 'P889977665', '2021-10-05', '2031-10-05', 11),
(12, 'P223355667', '2019-08-29', '2029-08-29', 12),
(13, 'P667788990', '2018-01-18', '2028-01-18', 13),
(14, 'P110022334', '2022-07-15', '2032-07-15', 14),
(15, 'P445566778', '2017-05-20', '2027-05-20', 15),
(16, 'P889900112', '2020-09-10', '2030-09-10', 16),
(17, 'P556677884', '2016-11-21', '2026-11-21', 17),
(18, 'P223344668', '2023-04-07', '2033-04-07', 18),
(19, 'P334455779', '2021-03-30', '2031-03-30', 19),
(20, 'P998877552', '2018-12-12', '2028-12-12', 20);
GO

------------------------------------#6-----------------------

-- Insertar datos en la tabla FrequentFlyerCard
INSERT INTO FrequentFlyerCard (FFCNumber, Miles, MealCode, CustomerID) VALUES
(1, 15000, 'Vegetariano', 1),
(2, 5000, 'Regular', 2),
(3, 25000, 'Vegetariano', 3),
(4, 10000, 'Kosher', 5),
(5, 2000, 'Regular', 6),
(6, 18000, 'Vegetariano', 7),
(7, 8000, 'Halal', 9),
(8, 22000, 'Vegetariano', 11),
(9, 3000, 'Regular', 13),
(10, 12000, 'Vegetariano', 15),
(11, 9000, 'Kosher', 17),
(12, 7000, 'Halal', 18),
(13, 26000, 'Vegetariano', 19),
(14, 11000, 'Regular', 20),
(15, 24000, 'Vegetariano', 10),
(16, 13000, 'Kosher', 12),
(17, 6000, 'Regular', 14),
(18, 19000, 'Vegetariano', 16),
(19, 50000, 'Regular', 4),
(20, 35000, 'Halal', 8);
GO
------------------------------------#7-----------------------

-- Insertar datos en la tabla TicketCategory
INSERT INTO TicketCategory (TicketCategoryID, CategoryName) VALUES
(1, 'Economy'),
(2, 'Business'),
(3, 'First Class'),
(4, 'Premium Economy'),
(5, 'Economy Plus'),
(6, 'Business Elite'),
(7, 'First Class Deluxe'),
(8, 'Premium Business'),
(9, 'Economy Comfort'),
(10, 'Business Premium'),
(11, 'First Class Premium'),
(12, 'Economy Basic'),
(13, 'Business Basic'),
(14, 'First Class Standard'),
(15, 'Economy Standard'),
(16, 'Business Comfort'),
(17, 'First Class Comfort'),
(18, 'Economy Deluxe'),
(19, 'Business Standard'),
(20, 'First Class Elite');
GO
------------------------------------#8-----------------------
-- Insertar datos en la tabla Ticket
INSERT INTO Ticket (TicketID, TicketingCode, Number, CategoryID, CustomerID) VALUES
(1, 'TK001', 100, 1, 1),
(2, 'TK002', 150, 2, 2),
(3, 'TK003', 200, 3, 3),
(4, 'TK004', 250, 4, 4),
(5, 'TK005', 300, 5, 5),
(6, 'TK006', 350, 6, 6),
(7, 'TK007', 400, 7, 7),
(8, 'TK008', 450, 8, 8),
(9, 'TK009', 500, 9, 9),
(10, 'TK010', 550, 10, 10),
(11, 'TK011', 600, 11, 11),
(12, 'TK012', 650, 12, 12),
(13, 'TK013', 700, 13, 13),
(14, 'TK014', 750, 14, 14),
(15, 'TK015', 800, 15, 15),
(16, 'TK016', 850, 16, 16),
(17, 'TK017', 900, 17, 17),
(18, 'TK018', 950, 18, 18),
(19, 'TK019', 1000, 19, 19),
(20, 'TK020', 1050, 20, 20);
GO
------------------------------------#9-----------------------

-- Insertar datos en la tabla Airport
INSERT INTO Airport (AirportID, Name, CityID) VALUES
(1, 'Aeropuerto Internacional El Alto', 1),
(2, 'Aeropuerto Internacional Viru Viru', 2),
(3, 'Aeropuerto Internacional Jorge Chávez', 3),
(4, 'Aeropuerto Internacional de Santiago', 4),
(5, 'Aeropuerto Internacional de São Paulo', 5),
(6, 'Aeropuerto Internacional de Buenos Aires', 6),
(7, 'Aeropuerto Internacional de Bogotá', 7),
(8, 'Aeropuerto Internacional de Quito', 8),
(9, 'Aeropuerto Internacional de Lima', 9),
(10, 'Aeropuerto Internacional de Caracas', 10),
(11, 'Aeropuerto Internacional de Miami', 11),
(12, 'Aeropuerto Internacional de Atlanta', 12),
(13, 'Aeropuerto Internacional de Madrid', 13),
(14, 'Aeropuerto Internacional de París', 14),
(15, 'Aeropuerto Internacional de Londres', 15),
(16, 'Aeropuerto Internacional de Roma', 16),
(17, 'Aeropuerto Internacional de Frankfurt', 17),
(18, 'Aeropuerto Internacional de Ámsterdam', 18),
(19, 'Aeropuerto Internacional de Tokio', 19),
(20, 'Aeropuerto Internacional de Seúl', 20);
GO
------------------------------------#10-----------------------

-- Insertar datos en la tabla PlaneModel
INSERT INTO PlaneModel (PlaneModelID, Description, Graphic) VALUES
(1, 'Boeing 737', '737-800'),
(2, 'Airbus A320', 'A320-200'),
(3, 'Boeing 747', '747-8'),
(4, 'Airbus A380', 'A380-800'),
(5, 'Boeing 787', '787-9'),
(6, 'Airbus A350', 'A350-900'),
(7, 'Boeing 767', '767-300'),
(8, 'Airbus A321', 'A321-200'),
(9, 'Boeing 757', '757-200'),
(10, 'Airbus A319', 'A319-100'),
(11, 'Boeing 787 Dreamliner', '787-8'),
(12, 'Airbus A310', 'A310-300'),
(13, 'Boeing 737 MAX', '737 MAX 8'),
(14, 'Airbus A330', 'A330-300'),
(15, 'Boeing 777', '777-300ER'),
(16, 'Airbus A220', 'A220-300'),
(17, 'Boeing 737 Next Generation', '737-700'),
(18, 'Airbus A321neo', 'A321neo'),
(19, 'Boeing 787-10', '787-10'),
(20, 'Airbus A350 XWB', 'A350-1000');
GO

------------------------------------#11-----------------------

-- Insertar datos en la tabla FlightNumber
INSERT INTO FlightNumber (FlightNumberID, DepartureTime, Description, Type, Airline, StartAirport, GoalAirport, PlaneModelID) VALUES
(1, '08:00:00', 'Vuelo a Nueva York', 'Nacional', 'American Airlines', 1, 11, 1),
(2, '09:30:00', 'Vuelo a Buenos Aires', 'Internacional', 'Aerolineas Argentinas', 2, 6, 2),
(3, '10:15:00', 'Vuelo a Madrid', 'Internacional', 'Iberia', 3, 13, 3),
(4, '11:45:00', 'Vuelo a Santiago', 'Internacional', 'LATAM', 4, 4, 4),
(5, '12:30:00', 'Vuelo a São Paulo', 'Internacional', 'Gol', 5, 5, 5),
(6, '13:00:00', 'Vuelo a Bogotá', 'Internacional', 'Avianca', 6, 7, 6),
(7, '14:15:00', 'Vuelo a Caracas', 'Internacional', 'Conviasa', 7, 10, 7),
(8, '15:30:00', 'Vuelo a Quito', 'Internacional', 'TAME', 8, 8, 8),
(9, '16:45:00', 'Vuelo a Lima', 'Internacional', 'Peruvian Airlines', 9, 9, 9),
(10, '17:15:00', 'Vuelo a Tokio', 'Internacional', 'Japan Airlines', 10, 19, 10),
(11, '18:00:00', 'Vuelo a Miami', 'Internacional', 'Delta Air Lines', 11, 11, 11),
(12, '19:30:00', 'Vuelo a Frankfurt', 'Internacional', 'Lufthansa', 12, 17, 12),
(13, '20:45:00', 'Vuelo a Roma', 'Internacional', 'Alitalia', 13, 16, 13),
(14, '21:00:00', 'Vuelo a Londres', 'Internacional', 'British Airways', 14, 15, 14),
(15, '22:30:00', 'Vuelo a Ámsterdam', 'Internacional', 'KLM', 15, 18, 15),
(16, '23:15:00', 'Vuelo a Seúl', 'Internacional', 'Korean Air', 16, 20, 16),
(17, '00:00:00', 'Vuelo a París', 'Internacional', 'Air France', 17, 14, 17),
(18, '01:30:00', 'Vuelo a Hong Kong', 'Internacional', 'Cathay Pacific', 18, 19, 18),
(19, '03:00:00', 'Vuelo a Los Ángeles', 'Internacional', 'United Airlines', 19, 11, 19),
(20, '04:45:00', 'Vuelo a Ciudad de México', 'Internacional', 'AeroMexico', 20, 3, 20);
GO

------------------------------------#12-----------------------

-- Insertar datos en la tabla FlightCategory
INSERT INTO FlightCategory (FlightCategoryID, CategoryName) VALUES
(1, 'Económica'),
(2, 'Primera Clase'),
(3, 'Business Class'),
(4, 'Premium Economy'),
(5, 'Clase Ejecutiva'),
(6, 'Clase Turista'),
(7, 'Clase Superior'),
(8, 'Clase Premium'),
(9, 'Clase Básica'),
(10, 'Clase Exclusiva'),
(11, 'Clase Familiar'),
(12, 'Clase Corporativa'),
(13, 'Clase VIP'),
(14, 'Clase Standard'),
(15, 'Clase Normal'),
(16, 'Clase Especial'),
(17, 'Clase Preferencial'),
(18, 'Clase Luxo'),
(19, 'Clase Familiar Plus'),
(20, 'Clase Ultra Premium');
GO

------------------------------------#13-----------------------

-- Insertar datos en la tabla Flight
INSERT INTO Flight (FlightID, BoardingTime, FlightDate, Gate, CheckInCounter, FlightNumberID, FlightCategoryID) VALUES
(1, '07:30:00', '2024-09-01', 'A1', '10', 1, 1),
(2, '09:00:00', '2024-09-01', 'B2', '12', 2, 2),
(3, '11:00:00', '2024-09-01', 'C3', '15', 3, 3),
(4, '13:00:00', '2024-09-01', 'D4', '18', 4, 4),
(5, '15:00:00', '2024-09-01', 'E5', '20', 5, 5),
(6, '17:00:00', '2024-09-01', 'F6', '22', 6, 6),
(7, '19:00:00', '2024-09-01', 'G7', '24', 7, 7),
(8, '21:00:00', '2024-09-01', 'H8', '26', 8, 8),
(9, '23:00:00', '2024-09-01', 'I9', '28', 9, 9),
(10, '01:00:00', '2024-09-02', 'J10', '30', 10, 10),
(11, '03:00:00', '2024-09-02', 'K11', '32', 11, 11),
(12, '05:00:00', '2024-09-02', 'L12', '34', 12, 12),
(13, '07:00:00', '2024-09-02', 'M13', '36', 13, 13),
(14, '09:00:00', '2024-09-02', 'N14', '38', 14, 14),
(15, '11:00:00', '2024-09-02', 'O15', '40', 15, 15),
(16, '13:00:00', '2024-09-02', 'P16', '42', 16, 16),
(17, '15:00:00', '2024-09-02', 'Q17', '44', 17, 17),
(18, '17:00:00', '2024-09-02', 'R18', '46', 18, 18),
(19, '19:00:00', '2024-09-02', 'S19', '48', 19, 19),
(20, '21:00:00', '2024-09-02', 'T20', '50', 20, 20);
GO


------------------------------------#14-----------------------

-- Insertar datos en la tabla Airplane
INSERT INTO Airplane (RegistrationNumber, BeginOperation, Status, PlaneModelID) VALUES
(1, '2010-01-01', 'En operación', 1),
(2, '2011-05-15', 'En operación', 2),
(3, '2012-10-10', 'En mantenimiento', 3),
(4, '2013-03-20', 'En operación', 4),
(5, '2014-07-25', 'En operación', 5),
(6, '2015-02-14', 'En operación', 6),
(7, '2016-06-30', 'En mantenimiento', 7),
(8, '2017-09-15', 'En operación', 8),
(9, '2018-01-22', 'En operación', 9),
(10, '2019-04-18', 'En mantenimiento', 10),
(11, '2020-08-12', 'En operación', 11),
(12, '2021-11-05', 'En operación', 12),
(13, '2022-07-30', 'En operación', 13),
(14, '2023-03-23', 'En mantenimiento', 14),
(15, '2024-01-15', 'En operación', 15),
(16, '2024-06-20', 'En operación', 16),
(17, '2024-08-10', 'En mantenimiento', 17),
(18, '2024-10-05', 'En operación', 18),
(19, '2024-11-15', 'En operación', 19),
(20, '2024-12-20', 'En mantenimiento', 20);
GO

------------------------------------#15-----------------------

-- Insertar datos en la tabla Seat
INSERT INTO Seat (SeatID, Size, Number, Location, PlaneModelID) VALUES
(1, 'Económica', 1, 'Fila 1, Asiento A', 1),
(2, 'Económica', 2, 'Fila 1, Asiento B', 1),
(3, 'Económica', 3, 'Fila 1, Asiento C', 2),
(4, 'Económica', 4, 'Fila 1, Asiento D', 2),
(5, 'Económica', 5, 'Fila 2, Asiento A', 3),
(6, 'Económica', 6, 'Fila 2, Asiento B', 3),
(7, 'Económica', 7, 'Fila 2, Asiento C', 4),
(8, 'Económica', 8, 'Fila 2, Asiento D', 4),
(9, 'Económica', 9, 'Fila 3, Asiento A', 5),
(10, 'Económica', 10, 'Fila 3, Asiento B', 5),
(11, 'Económica', 11, 'Fila 3, Asiento C', 6),
(12, 'Económica', 12, 'Fila 3, Asiento D', 6),
(13, 'Primera Clase', 13, 'Fila 4, Asiento A', 7),
(14, 'Primera Clase', 14, 'Fila 4, Asiento B', 7),
(15, 'Primera Clase', 15, 'Fila 4, Asiento C', 8),
(16, 'Primera Clase', 16, 'Fila 4, Asiento D', 8),
(17, 'Económica', 17, 'Fila 5, Asiento A', 9),
(18, 'Económica', 18, 'Fila 5, Asiento B', 9),
(19, 'Económica', 19, 'Fila 5, Asiento C', 10),
(20, 'Económica', 20, 'Fila 5, Asiento D', 10);
GO
------------------------------------#16-----------------------

-- Insertar datos en la tabla Coupon
INSERT INTO Coupon (CouponID, DateOfRedemption, Class, Standby, MealCode, TicketID, FlightID) VALUES
(1, '2024-09-01', 'Económica', 0, 'Vegetariano', 1, 1),
(2, '2024-09-02', 'Económica', 0, 'Regular', 2, 2),
(3, '2024-09-03', 'Primera Clase', 0, 'Kosher', 3, 3),
(4, '2024-09-04', 'Económica', 1, 'Halal', 4, 4),
(5, '2024-09-05', 'Económica', 0, 'Vegetariano', 5, 5),
(6, '2024-09-06', 'Primera Clase', 1, 'Regular', 6, 6),
(7, '2024-09-07', 'Económica', 0, 'Kosher', 7, 7),
(8, '2024-09-08', 'Económica', 1, 'Halal', 8, 8),
(9, '2024-09-09', 'Primera Clase', 0, 'Vegetariano', 9, 9),
(10, '2024-09-10', 'Económica', 0, 'Regular', 10, 10),
(11, '2024-09-11', 'Económica', 1, 'Kosher', 11, 11),
(12, '2024-09-12', 'Primera Clase', 0, 'Halal', 12, 12),
(13, '2024-09-13', 'Económica', 0, 'Vegetariano', 13, 13),
(14, '2024-09-14', 'Económica', 1, 'Regular', 14, 14),
(15, '2024-09-15', 'Primera Clase', 0, 'Kosher', 15, 15),
(16, '2024-09-16', 'Económica', 0, 'Halal', 16, 16),
(17, '2024-09-17', 'Económica', 1, 'Vegetariano', 17, 17),
(18, '2024-09-18', 'Primera Clase', 0, 'Regular', 18, 18),
(19, '2024-09-19', 'Económica', 0, 'Kosher', 19, 19),
(20, '2024-09-20', 'Económica', 1, 'Halal', 20, 20);
GO

------------------------------------#17-----------------------

-- Insertar datos en la tabla PiecesOfLuggage
INSERT INTO PiecesOfLuggage (Number, Weight, CouponID) VALUES
(1, 23.50, 1),
(2, 15.00, 2),
(3, 30.75, 3),
(4, 10.25, 4),
(5, 20.00, 5),
(6, 25.50, 6),
(7, 18.00, 7),
(8, 22.00, 8),
(9, 12.50, 9),
(10, 14.75, 10),
(11, 28.00, 11),
(12, 16.50, 12),
(13, 19.25, 13),
(14, 21.00, 14),
(15, 17.75, 15),
(16, 24.00, 16),
(17, 13.00, 17),
(18, 27.50, 18),
(19, 29.00, 19),
(20, 26.00, 20);
GO

------------------------------------#18-----------------------

-- Insertar datos en la tabla AvailableSeat
INSERT INTO AvailableSeat (AvailableSeatID, FlightID, SeatID, CouponID) VALUES
(1, 1, 1, 1),
(2, 1, 2, 2),
(3, 1, 3, 3),
(4, 1, 4, 4),
(5, 2, 5, 5),
(6, 2, 6, 6),
(7, 2, 7, 7),
(8, 2, 8, 8),
(9, 3, 9, 9),
(10, 3, 10, 10),
(11, 3, 11, 11),
(12, 3, 12, 12),
(13, 4, 13, 13),
(14, 4, 14, 14),
(15, 4, 15, 15),
(16, 4, 16, 16),
(17, 5, 17, 17),
(18, 5, 18, 18),
(19, 5, 19, 19),
(20, 5, 20, 20);
GO
----------------------------------------------------------
/*
Select * From Country                 --1
Select * From City                    --2
Select * From CustomerCategory        --3
Select * From Customer                --4
Select * From Document                --5
Select * From FrequentFlyerCard       --6
Select * From TicketCategory          --7
Select * From Ticket                  --8
Select * From Airport                 --9
Select * From PlaneModel              --10
Select * From FlightNumber            --11
Select * From FlightCategory          --12
Select * From Flight                  --13
Select * From Airplane                --14
Select * From Seat                    --15
Select * From Coupon                  --16
Select * From PiecesOfLuggage         --17
Select * From AvailableSeat           --18
*/
