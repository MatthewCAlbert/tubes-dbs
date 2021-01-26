-- Data Definition Language
CREATE TABLE RoomTypes(
    id INT PRIMARY KEY,
    "name" VARCHAR(32),
    price NUMERIC
);

CREATE TABLE Rooms(
    id INT PRIMARY KEY,
    roomtype_id INT,
    "no" VARCHAR(10) UNIQUE,
    info VARCHAR(255),
    FOREIGN KEY (roomtype_id) REFERENCES RoomTypes(id)
);

CREATE TABLE Users(
    id UNIQUEIDENTIFIER PRIMARY KEY,
    email VARCHAR(320) UNIQUE,
    "password" VARBINARY(8000),
    title VARCHAR(6),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    "address" VARCHAR(255),
    country VARCHAR(32),
    phone_num VARCHAR(32),
    birth_date DATE,
    created_on  DATETIME
);

CREATE TABLE Payments(
    id UNIQUEIDENTIFIER PRIMARY KEY,
    amount NUMERIC,
    method VARCHAR(20),
    "status" INT,
    "time" DATETIME
);

CREATE TABLE Coupons(
    id UNIQUEIDENTIFIER PRIMARY KEY,
    code VARCHAR(32),
    valid_from DATETIME,
    expired_on DATETIME,
    quota INT,
    "value" NUMERIC
);

CREATE TABLE Bookings(
    id UNIQUEIDENTIFIER PRIMARY KEY,
    "user_id" UNIQUEIDENTIFIER,
    room_id INT,
    payment_id UNIQUEIDENTIFIER,
    coupon_id UNIQUEIDENTIFIER,
    "start" DATE,
    "end" DATE,
    "status" INT,
    created_on DATETIME,
    FOREIGN KEY ("user_id") REFERENCES Users(id),
    FOREIGN KEY (room_id) REFERENCES Rooms(id),
    FOREIGN KEY (payment_id) REFERENCES Payments(id),
    FOREIGN KEY (coupon_id) REFERENCES Coupons(id)
);

-- Check created table
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE';

-- Drop all tables
DROP TABLE Bookings;
DROP TABLE "Users";
DROP TABLE Payments;
DROP TABLE Rooms;
DROP TABLE RoomTypes;
DROP TABLE Coupons;