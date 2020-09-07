-- Creating Table: Territories
CREATE TABLE Territories (
    TerritoryID INT NOT NULL AUTO_INCREMENT,
    Territory VARCHAR(5) NOT NULL,
    PRIMARY KEY (TerritoryID)
);

-- Creating Table: Countries
CREATE TABLE Countries (
    CountryID INT NOT NULL AUTO_INCREMENT,
    Country VARCHAR(20) NOT NULL,
    TerritoryID INT,
    PRIMARY KEY (CountryID),
    FOREIGN KEY (TerritoryID)
        REFERENCES Territories (TerritoryID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Creating Table: Cities
CREATE TABLE Cities (
    CityID INT NOT NULL AUTO_INCREMENT,
    City VARCHAR(20) NOT NULL,
    State VARCHAR(20),
    CountryID INT,
    PRIMARY KEY (CityID),
    FOREIGN KEY (CountryID)
        REFERENCES Countries (CountryID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Creating Table: Customers
CREATE TABLE Customers (
    CustomerID INT NOT NULL AUTO_INCREMENT,
    CustomerName VARCHAR(50) NOT NULL,
    ContactLastName VARCHAR(20),
    ContactFirstName VARCHAR(20),
    Phone VARCHAR(25),
    AddressLine1 VARCHAR(60),
    AddressLine2 VARCHAR(20),
    PostalCode VARCHAR(15),
    CityID INT,
    PRIMARY KEY (CustomerID),
    FOREIGN KEY (CityID)
        REFERENCES Cities (CityID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Creating Table: Status
CREATE TABLE Status (
    StatusID INT NOT NULL AUTO_INCREMENT,
    Status VARCHAR(15),
    PRIMARY KEY (StatusID)
);

-- Creating Table: Orders
CREATE TABLE Orders (
    OrderID INT NOT NULL AUTO_INCREMENT,
    OrderNumber INT(5),
    OrderDate DATE,
    Quarter INT,
    Month INT,
    Year INT,
    StatusID INT,
    CustomerID INT,
    PRIMARY KEY (OrderID),
    FOREIGN KEY (StatusID)
        REFERENCES Status (StatusID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (CustomerID)
        REFERENCES Customers (CustomerID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Creating Table: ProductLines
CREATE TABLE ProductLines (
    ProductLineID INT NOT NULL AUTO_INCREMENT,
    ProductLine VARCHAR(20),
    PRIMARY KEY (ProductLineID)
);

-- Creating Table: Products
CREATE TABLE Products (
    ProductID INT NOT NULL AUTO_INCREMENT,
    ProductCode CHAR(9),
	MSRP INT,
    ProductLineID INT,
    PRIMARY KEY (ProductID),
    FOREIGN KEY (ProductLineID)
        REFERENCES ProductLines (ProductlineID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Creating Table: DealSizes
CREATE TABLE DealSizes (
    SizeID INT NOT NULL AUTO_INCREMENT,
    DealSize VARCHAR(6),
    PRIMARY KEY (SizeID)
);

-- Creating Table: Orders_Products
CREATE TABLE Orders_Products (
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT,
    PriceEach FLOAT,
    OrderLineNumber INT,
    Sales FLOAT,
    SizeID INT,
    PRIMARY KEY (OrderID , ProductID),
    FOREIGN KEY (OrderID)
        REFERENCES Orders (OrderID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ProductID)
        REFERENCES Products (ProductID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (SizeID)
        REFERENCES DealSizes (SizeID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

