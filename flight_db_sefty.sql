CREATE TABLE PERSONAL_INFO (
  PERSONAL_ID INT identity(1,1) PRIMARY KEY,
  FIRST_NAME VARCHAR(20) NOT NULL,
  LAST_NAME VARCHAR(20) NOT NULL,
  FATHER_NAME VARCHAR(20),
  BIETHDAY DATE NOT NULL CHECK (BIETHDAY < GETDATE() AND BIETHDAY >= '1900-01-01'),
  National_number VARCHAR(20) NOT NULL UNIQUE,
  GENDER VARCHAR(10) NOT NULL,

);
--------------------------------------------------------
CREATE TABLE PHONENUMBER (
  PhonenumberID INT identity(1,1) PRIMARY KEY,
  PhoneNumber VARCHAR(10) NOT NULL CHECK (LEN(PhoneNumber) = 10),
  PERSONAL_ID INT NOT NULL,
  FOREIGN KEY (PERSONAL_ID) REFERENCES PERSONAL_INFO(PERSONAL_ID)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  );
-------------------------------------------------------

CREATE TABLE ADDRESSTABLE (
  AddressID INT identity(1,1) PRIMARY KEY,
  PERSONAL_ID INT NOT NULL,
  ADDRESSINFO VARCHAR(300)
  FOREIGN KEY (PERSONAL_ID) REFERENCES PERSONAL_INFO(PERSONAL_ID)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  );
--------------------------------------------------------
  CREATE TABLE NATIONALITY (
  NATIONALITYID INT identity(1,1) PRIMARY KEY,
  PERSONAL_ID INT NOT NULL,
  NATIONALITYINFO VARCHAR(100) NOT NULL
  FOREIGN KEY (PERSONAL_ID) REFERENCES PERSONAL_INFO(PERSONAL_ID)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  );
--------------------------------------------------------

  CREATE TABLE EMAIL (
  EmailID INT identity(1,1) PRIMARY KEY,
  PERSONAL_ID INT NOT NULL,
  emailAddress VARCHAR(100) NOT NULL
  FOREIGN KEY (PERSONAL_ID) REFERENCES PERSONAL_INFO(PERSONAL_ID)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  );
  --------------------------------------------------------
  CREATE TABLE PlaneConfiguration (
  PlaneConfigurationID INT identity(1,1) PRIMARY KEY,
  Model VARCHAR(100) NOT NULL,
  SeatingCapacity int not null,
  FirstClassSeats int not null check(FirstClassSeats <= 21),
  BusinessClassSeats int not null check(BusinessClassSeats <= 30),
  EconomicClassSeats int not null check(EconomicClassSeats <= 80)
  );
  --------------------------------------------------------
  CREATE TABLE PLANE (
  PlaneID INT identity(1,1) PRIMARY KEY,
  PlaneType VARCHAR(100) NOT NULL,
  Manufacturer  VARCHAR(100) not null,
  PlaneConfigurationID int not null,

  FOREIGN KEY (PlaneConfigurationID) REFERENCES PlaneConfiguration(PlaneConfigurationID)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  );
-----------------------------------------------------------
  CREATE TABLE Itinerary (
  FlightNumber INT identity(1,1) PRIMARY KEY,
  DepartureCity VARCHAR(100) NOT NULL,
  DepartureTime Date not null,
  ArrivalCity  VARCHAR(100) not null,
  ArrivalTime Date not null,
  Duration int not null,
  NumberOfStopsCites int not null,
  PriceOfFirstClassTicket float not null check(PriceOfFirstClassTicket > 0),
  PriceOfBusinessClassTicket float not null check(PriceOfBusinessClassTicket > 0),
  PriceOfEconomyClassTicket float not null check(PriceOfEconomyClassTicket > 0),
  check(ArrivalTime>DepartureTime)
 );
 -----------------------------------------------------------
 
CREATE TABLE PricesCategories  (
CategoryID INT identity(1,1) PRIMARY KEY,
CategoryName  VARCHAR(20) unique not null,
CategoryPrice  float not null check(CategoryPrice>0),
OffersPercent float 
);
 -----------------------------------------------------------
 
  CREATE TABLE Customer (
  CustomerID INT identity(1,1) PRIMARY KEY,
  PERSONAL_ID INT NOT NULL,
  FlightsCount Int ,
  LastReservationDate Date,

  FOREIGN KEY (PERSONAL_ID) REFERENCES PERSONAL_INFO(PERSONAL_ID)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  );
 -----------------------------------------------------------

  CREATE TABLE ReservationEmployee(
  ReservationEmpID INT identity(1,1) PRIMARY KEY,
  PERSONAL_ID INT NOT NULL,
  Salary  float NOT NULL check(Salary>0),
  HairDate Date not null check (HairDate < GETDATE()+1),
  Evaluation Int not null check(Evaluation between 0 and 100),

  FOREIGN KEY (PERSONAL_ID) REFERENCES PERSONAL_INFO(PERSONAL_ID)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  );
 -----------------------------------------------------------

  CREATE TABLE ServiceEmployee(
  ServiceEmpID INT identity(1,1) PRIMARY KEY,
  PERSONAL_ID INT NOT NULL,
  Salary  float NOT NULL check(Salary>0),
  HairDate Date not null check (HairDate < GETDATE()+1),
  Evaluation Int not null check(Evaluation between 0 and 100),

  FOREIGN KEY (PERSONAL_ID) REFERENCES PERSONAL_INFO(PERSONAL_ID)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  );
 -----------------------------------------------------------

  CREATE TABLE SalesEmployee(
  SalesEmpID INT identity(1,1) PRIMARY KEY,
  PERSONAL_ID INT NOT NULL,
  Salary  float NOT NULL check(Salary>0),
  HairDate Date not null check (HairDate < GETDATE()+1),
  Evaluation Int not null check(Evaluation between 0 and 100),

  FOREIGN KEY (PERSONAL_ID) REFERENCES PERSONAL_INFO(PERSONAL_ID)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  );

 -----------------------------------------------------------

  CREATE TABLE PaymentMethod(
  PaymentMethodID INT identity(1,1) PRIMARY KEY, 
  PaymentType VARCHAR(50) unique not null, 
  );

-----------------------------------------------------------

  CREATE TABLE ServicesIndex(
  ServicesID INT identity(1,1) PRIMARY KEY, 
  ServiceName VARCHAR(100) unique not null,
  ServicePrice float not null check(ServicePrice>0)
  );
-----------------------------------------------------------

 CREATE TABLE FlightsTime (
	FlightTimeID int identity(1,1)  PRIMARY KEY,
	FlightNumber INT not null,
	FlightDate Date not null,

	unique(FlightNumber,FlightDate),
	FOREIGN KEY (FlightNumber) REFERENCES Itinerary(FlightNumber)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
);
 -----------------------------------------------------------

CREATE TABLE Flight (
	FlightID INT identity(1,1) PRIMARY KEY,
	--FlightNumber INT not null,
	--FlightDate Date not null,
	FlightTimeID INT not null,
	PlaneID int not null,
	FlightStatus VARCHAR(20) not null,
	PassengersCount int not null check(PassengersCount>0),
	AllowedWeight int not null check(AllowedWeight>0),

	--PRIMARY key (FlightNumber, FlightDate) ,

--	FOREIGN KEY (FlightNumber) REFERENCES Itinerary(FlightNumber)
	--ON DELETE CASCADE
	--ON UPDATE CASCADE,

	FOREIGN KEY (FlightTimeID) REFERENCES FlightsTime(FlightTimeID)
	ON DELETE NO ACTION
	ON UPDATE CASCADE,

	FOREIGN KEY (PlaneID) REFERENCES PLANE(PlaneID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,

);
 -----------------------------------------------------------
 CREATE TABLE Reservation  (
	ReservationID INT identity(1,1) PRIMARY KEY,
	--FlightNumber INT not null,
	--FlightDate Date not null ,
	FlightID int not null,
	--FlightTimeID int not null,
	CustomerID int not null,
	TravelClass VARCHAR(50) not null,
	AgeCategoryId int not null,
	Price float not null check(Price>0),
	ReservationEmployeeId int not null,
	CalculatedPrice  Float Not Null,
	--FOREIGN KEY (FlightTimeID) REFERENCES FlightsTime(FlightTimeID)
	--ON DELETE CASCADE
	--ON UPDATE CASCADE,

	FOREIGN KEY (FlightID) REFERENCES Flight(FlightID)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
	--primary key (FlightNumber, FlightDate) ,

	--FOREIGN KEY (FlightNumber, FlightDate) REFERENCES Flight(FlightNumber, FlightDate)
		  --  ON DELETE CASCADE
		--    ON UPDATE CASCADE,
	FOREIGN KEY (ReservationEmployeeId ) REFERENCES ReservationEmployee(ReservationEmpID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,

	FOREIGN KEY (AgeCategoryId ) REFERENCES PricesCategories(CategoryID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,

	
	);
	--ALTER TABLE Reservation ADD CONSTRAINT unique_flight_number_and_date UNIQUE (FlightNumber, FlightDate);
	--to calculate the price according to age Category 
	CREATE TRIGGER CalculatePrice  ON Reservation
	AFTER INSERT, UPDATE
	AS
	BEGIN
	UPDATE Reservation
	SET CalculatedPrice = (SELECT CategoryPrice FROM PricesCategories WHERE CategoryID = AgeCategoryId) * Price
	WHERE ReservationID IN (SELECT ReservationID FROM inserted);
	END;

 -----------------------------------------------------------

  CREATE TABLE FlightTicket(
  FlightTicketID INT identity(1,1) PRIMARY KEY, 
  CustomerID INT not null,
 -- ReservationID INT not null,
 -- FlightTimeID INT not null,
  FlightID INT not null,
  FlightFrom date not null,
  FlightTo date not null,
  SeatNumber VARCHAR(20) not null,
  Class VARCHAR(20) not null,
  Price Float not null ,
  Discount float ,

  check (FlightTo> FlightFrom),
  FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
  ON DELETE CASCADE
  ON UPDATE CASCADE,

	FOREIGN KEY (FlightID) REFERENCES Flight(FlightID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
  
  );
------------------------------------------------------------
CREATE TABLE Cart (
 CartID  INT identity(1,1) PRIMARY KEY, 
 CustomerID INT not null, 
 ServiceID INT not null,
 Quantity float not null,
 UnitPrice float not null,
 CreateDate  Date default getdate(),
 TotalPrice float not null,

 	FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,

	FOREIGN KEY (ServiceID) REFERENCES ServicesIndex(ServicesID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,

);
------------------------------------------------------------
 CREATE TABLE OrderStatus(
 StatusID  INT identity(1,1) PRIMARY KEY, 
 StatusType Varchar(50) not null, 

);
------------------------------------------------------------
 CREATE TABLE OrderTable(
 OrderID  INT identity(1,1) PRIMARY KEY, 
 CartID int  not null, 
 PaymentMethodID int  not null, 
 StatusID int  not null, 

  	FOREIGN KEY (CartID) REFERENCES Cart(CartID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,

	FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethod(PaymentMethodID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,

	FOREIGN KEY (StatusID) REFERENCES OrderStatus(StatusID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,

);
------------------------------------------------------------
CREATE TABLE ServiceTicket(
 ServiceTicketID INT identity(1,1) PRIMARY KEY, 
  CustomerID INT not null,
  ServiceID INT not null,
  DateRequested date not null,
  DateCompleted date not null,
  ServiceDescription VARCHAR(255) not null,
  Discount float ,

  check (DateCompleted>= DateRequested),
  FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
  ON DELETE CASCADE
  ON UPDATE CASCADE,

	FOREIGN KEY (ServiceID) REFERENCES ServicesIndex(ServicesID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
  
); 
------------------------------------------------------------
 CREATE TABLE Invoic(
 InvoicID  INT identity(1,1) PRIMARY KEY, 
 OrderID INT not null,
 TotalAmount float not null,
 invoiceDate Date default getdate(),

   	FOREIGN KEY (OrderID) REFERENCES OrderTable(OrderID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
);


