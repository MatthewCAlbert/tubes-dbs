-- PROCEDURE

-- login()
CREATE PROCEDURE accountLogin
	@email varchar(320),
    @password varchar(64)
AS
BEGIN
    SELECT dbo.verifyPassword(@password, password) AS result FROM Users WHERE email = @email;
END;

GO;

-- changePassword()
CREATE PROCEDURE changePassword
	@user_id UNIQUEIDENTIFIER,
	@old_password varchar(64),
    @new_password varchar(64)
AS
BEGIN
    IF (SELECT dbo.verifyPassword(@old_password, "password") FROM Users WHERE id = @user_id) = 1
        BEGIN
            UPDATE Users SET "password" = dbo.hashPassword(@new_password) WHERE id = @user_id;
            PRINT 'Password successfully changed';
        END
    ELSE
        PRINT 'Invalid Credentials';
END;

GO;

-- forceChangePassword()
CREATE PROCEDURE forceChangePassword
	@user_id UNIQUEIDENTIFIER,
    @new_password varchar(64)
AS
BEGIN
    UPDATE Users SET "password" = dbo.hashPassword(@new_password) WHERE id = @user_id;
    PRINT 'Password successfully changed';
END;

GO;

-- createAccount()
CREATE PROCEDURE createAccount
	@email varchar(320),
    @password varchar(64),
    @title varchar(6),
    @first_name varchar(255),
    @last_name varchar(255),
    @address varchar(255),
    @country varchar(32),
    @phone_num varchar(30),
    @birth_date date
AS
BEGIN
    INSERT INTO Users(id,
                email,
                password,
                title,
                first_name,
                last_name,
                address,
                country,
                phone_num,
                birth_date,
                created_on)
    VALUES
        (NEWID(),
        @email,
        dbo.hashPassword(@password),
        @title,
        @first_name,
        @last_name,
        @address,
        @country,
        @phone_num,
        @birth_date,
        getutcdate())
END;

GO;      

-- editAccount()
CREATE PROCEDURE editAccountInfo
	@id UNIQUEIDENTIFIER,
    @title varchar(6),
    @first_name varchar(255),
    @last_name varchar(255),
    @address varchar(255),
    @country varchar(32),
    @phone_num varchar(30),
    @birth_date date
AS
BEGIN
	SELECT * FROM Users
	UPDATE Users
	SET
		title = @title,
		first_name = @first_name,
		last_name = @last_name,
		"address" = @address,
		country = @country,
		phone_num = @phone_num,
        birth_date = @birth_date
	WHERE id = @id;
END;

GO;

-- bookRoom() start: check in + end: check out DATE
CREATE PROCEDURE bookRoom
    @user_id UNIQUEIDENTIFIER, 
    @room_id INT, 
    @start DATE, 
    @end DATE, 
    @coupon_code VARCHAR(32) = NULL
AS
BEGIN
    DECLARE @c_id UNIQUEIDENTIFIER = dbo.checkCoupon(@coupon_code);

    IF @c_id IS NULL AND @coupon_code IS NOT NULL
    BEGIN
        PRINT 'Coupon not valid!';
        RETURN;
    END

    IF @start < getutcdate()
    BEGIN
        PRINT 'Cannot book in the past!';
        RETURN;
    END

    IF @start > @end
    BEGIN
        PRINT 'End must be bigger or equal than start!';
        RETURN;
    END


    IF ( dbo.checkRoomAvailable(@room_id, @start, @end) ) = 1
        BEGIN
            DECLARE @b_id UNIQUEIDENTIFIER = NEWID();
            DECLARE @buffer NVARCHAR(MAX) = @b_id;
            INSERT INTO Bookings(id, user_id, room_id, payment_id, coupon_id, "start", "end", "status") 
            VALUES (@b_id, @user_id, @room_id, NULL, @c_id, @start, DATEADD(DAY,-1, @end), 0);
            PRINT 'Booking Success';
            PRINT 'Booking ID #'+@buffer;
        END
    ELSE
        PRINT 'Booking Failed';
END;

GO;

-- getAvailableRoom()
CREATE PROCEDURE getAvailableRoom
    @start DATE, 
    @end DATE,
    @roomtype_id INT = NULL
AS
BEGIN
    IF @roomtype_id IS NULL
        BEGIN
            SELECT * FROM Rooms WHERE id NOT IN
            (SELECT r.id FROM Rooms AS r
            INNER JOIN Bookings AS b ON r.id = b.room_id 
            WHERE (@start BETWEEN b."start" AND b."end") OR (@end BETWEEN b."start" AND b."end") AND (b."status" != 3 AND b."status" != 5));
        END
    ELSE
        BEGIN
            SELECT * FROM Rooms WHERE id NOT IN
            (SELECT r.id FROM Rooms AS r
            INNER JOIN Bookings AS b ON r.id = b.room_id 
            WHERE (@start BETWEEN b."start" AND b."end") OR (@end BETWEEN b."start" AND b."end") AND (b."status" != 3 AND b."status" != 5)) AND roomtype_id = @roomtype_id;

            SELECT dbo.getRoomPrice(@roomtype_id,NULL,@start, DATEADD(DAY,-1, @end), NULL) AS totalPrice;
        END
END;

GO;

-- createCoupon() use time in UTC+7
CREATE PROCEDURE createCoupon
    @code VARCHAR(32), 
    @valid_from DATETIME,
    @expired_on DATETIME,
    @quota INT,
    @value NUMERIC
AS
BEGIN
    IF @quota <= 0
    BEGIN
        PRINT 'Coupon quota cannot be less than 1!';
        RETURN;
    END

    IF @value <= 0
    BEGIN
        PRINT 'Coupon value cannot be less than 1!';
        RETURN;
    END

    IF @valid_from >= @expired_on
    BEGIN
        PRINT 'Expired must be bigger than start!';
        RETURN;
    END

    IF (SELECT COUNT(*) FROM Coupons WHERE code = @code AND ((valid_from BETWEEN @valid_from AND @expired_on) OR (expired_on BETWEEN @valid_from AND @expired_on))) > 0
    BEGIN
        PRINT 'Cannot create same code with overlapped time!';
        RETURN;
    END

    INSERT INTO Coupons VALUES
        (NEWID(),@code, DATEADD(hour, -7, @valid_from),DATEADD(hour, -7, @expired_on),@quota,@value);
    PRINT 'Coupon successfully created!';
END;

GO;

-- getBooking()
CREATE PROCEDURE getBooking
    @booking_id UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @booking TABLE(id UNIQUEIDENTIFIER, "user_id" UNIQUEIDENTIFIER, room_id INT, payment_id UNIQUEIDENTIFIER, coupon_id UNIQUEIDENTIFIER, "start" DATE, "end" DATE, "status" INT, created_on DATETIME);
    INSERT INTO @booking SELECT * FROM Bookings WHERE id = @booking_id
    
    DECLARE @coupon TABLE(code VARCHAR(32),"value" NUMERIC);

    DECLARE @payment TABLE(id UNIQUEIDENTIFIER,amount NUMERIC,method VARCHAR(20),"status" INT,"time" DATETIME)
    INSERT INTO @payment SELECT id,amount,method,"status","time" FROM Payments WHERE id = (SELECT payment_id FROM @booking);

    DECLARE @room TABLE(id INT, roomtype_id INT,"no" VARCHAR(10),info VARCHAR(255));
    INSERT INTO @room SELECT * FROM Rooms WHERE id = (SELECT room_id FROM @booking);

    DECLARE @user 
        TABLE(
        email VARCHAR(320),title VARCHAR(6),first_name VARCHAR(255),last_name VARCHAR(255),"address" VARCHAR(255),country VARCHAR(32),phone_num VARCHAR(32));
    INSERT INTO @user SELECT email,title,first_name,last_name,"address",country,phone_num FROM Users WHERE id = (SELECT "user_id" FROM @booking);
    

    DECLARE @buffer NVARCHAR(MAX) = '';

    SET @buffer = (SELECT id FROM @booking);
    PRINT 'Booking Id #'+@buffer;
    SET @buffer = DATEADD(hour, 7, (SELECT created_on FROM @booking));
    PRINT 'Date (UTC+7): '+@buffer;
    DECLARE @dur INT = DATEDIFF(day, (SELECT "start" FROM @booking),(SELECT "end" FROM @booking))+1;
    SET @buffer = @dur;
    PRINT 'Duration: '+@buffer+ CASE 
        WHEN @dur > 1 THEN ' nights' 
        ELSE ' night' 
    END;
    SET @buffer = (SELECT "start" FROM @booking);
    PRINT 'Check-in: '+@buffer+' 12:00 PM';
    SET @buffer = (SELECT DATEADD(DAY,1, "end") FROM @booking);
    PRINT 'Check-out: '+@buffer+' 12:00 PM';
    SET @buffer = dbo.getStatusCodeInfo((SELECT "status" FROM @booking),'bookings');
    PRINT 'Status: '+@buffer;

    PRINT '';

    IF (SELECT coupon_id FROM @booking) IS NOT NULL
    BEGIN
        INSERT @coupon SELECT code,"value" FROM Coupons WHERE id = (SELECT coupon_id FROM @booking);
        PRINT 'Used Coupon Info:'
        SET @buffer = (SELECT code FROM @coupon);
        PRINT 'Code: '+@buffer;
        SET @buffer = CONVERT(NVARCHAR, CAST((SELECT "value" FROM @coupon) AS money), 1);
        PRINT 'Value: IDR '+@buffer;
    END

    PRINT '';

    PRINT 'Payment Info:'
    SET @buffer = (SELECT id FROM @payment);
    PRINT 'ID: #'+@buffer;
    SET @buffer = CONVERT(NVARCHAR, CAST((SELECT amount FROM @payment) AS money), 1);
    PRINT 'Amount: IDR '+@buffer;
    SET @buffer = (SELECT method FROM @payment);
    PRINT 'Method: '+@buffer;
    SET @buffer = dbo.getStatusCodeInfo((SELECT "status" FROM @payment),'payments');
    PRINT 'Status: '+@buffer;
    SET @buffer = (SELECT "time" FROM @payment);
    PRINT 'Payment Time: '+@buffer;

    PRINT '';

    PRINT 'Room Info: '
    SET @buffer = (SELECT "name" FROM RoomTypes WHERE id = (SELECT roomtype_id FROM @room));
    PRINT 'Type: '+@buffer;
    SET @buffer = (SELECT "no" FROM @room);
    PRINT 'No: '+@buffer;
     SET @buffer = (SELECT info FROM @room);
    PRINT 'Info: '+@buffer;

    PRINT 'Guest Info: '
    SET @buffer = (SELECT email FROM @user);
    PRINT 'Email: '+@buffer;
    SET @buffer = (SELECT title FROM @user)+'. '+(SELECT last_name FROM @user)+', '+(SELECT first_name FROM @user);
    PRINT 'Name: '+@buffer;
    SET @buffer = (SELECT "address" FROM @user)+', '+(SELECT country FROM @user);
    PRINT 'Address: '+@buffer;
    SET @buffer = (SELECT phone_num FROM @user);
    PRINT 'Phone: '+@buffer;
END;

GO;

-- checkIn()
CREATE PROCEDURE checkIn
    @booking_id UNIQUEIDENTIFIER
AS
BEGIN
    DECLARE @booking TABLE(room_id INT, payment_id UNIQUEIDENTIFIER, "user_id" UNIQUEIDENTIFIER, "start" DATE, "end" DATE, "status" INT, payment_status INT);
    INSERT INTO @booking
    SELECT b.room_id, b.payment_id, b."user_id", b."start",b."end",b."status",p."status" AS payment_status  FROM Bookings as b INNER JOIN Payments as p ON b.payment_id = p.id WHERE b.id = @booking_id;


    IF 
        (SELECT "status" FROM @booking) = 1 OR (SELECT "status" FROM @booking) = 4 
        OR 
        (SELECT payment_status FROM @booking) = 1 OR (SELECT payment_status FROM @booking) = 4
        BEGIN
            DECLARE @user 
                TABLE(title VARCHAR(6),first_name VARCHAR(255),last_name VARCHAR(255));
            INSERT INTO @user SELECT title,first_name,last_name FROM Users WHERE id = (SELECT "user_id" FROM @booking);
            
            DECLARE @buffer NVARCHAR(MAX);
            SET @buffer = (SELECT title FROM @user)+'. '+(SELECT last_name FROM @user)+', '+(SELECT first_name FROM @user);
            PRINT 'Guest: '+@buffer;
            PRINT 'Check In OK!'

            SET @buffer = (SELECT "start" FROM @booking);
            PRINT 'Check-in: '+@buffer+' 12:00 PM';
            SET @buffer = (SELECT DATEADD(DAY,1, "end") FROM @booking);
            PRINT 'Check-out: '+@buffer+' 12:00 PM';
        END
    ELSE
        PRINT 'Check In Denied!'
END;

GO;

-- confirmPayment()
CREATE PROCEDURE confirmPayment
	@payment_id UNIQUEIDENTIFIER
AS
BEGIN
	UPDATE Payments
	SET
		"status" = 1,
        "time" = getutcdate()
	WHERE id = @payment_id;

    UPDATE Bookings SET "status" = 1 WHERE payment_id = @payment_id;
    PRINT 'Payment Success'
END;

GO;

-- requestCancel()
CREATE PROCEDURE requestCancel
	@booking_id UNIQUEIDENTIFIER
AS
BEGIN
    IF (SELECT "status" FROM Payments WHERE id = (SELECT payment_id FROM Bookings WHERE id = @booking_id)) = 1
        BEGIN
            UPDATE Bookings
            SET
                "status" = 2
            WHERE id = @booking_id;
            PRINT 'Cancellation Requested';
        END
    ELSE
        PRINT 'Cancellation Request Invalid';
END;

GO;

-- respondCancellation()
CREATE PROCEDURE respondCancellation
	@payment_id UNIQUEIDENTIFIER,
	@allow INT
AS
BEGIN
    IF (SELECT "status" FROM Payments WHERE id = @payment_id) = 2
    BEGIN
        IF @allow = 1
        BEGIN
            UPDATE Payments
            SET
                "status" = 3
            WHERE id = @payment_id
            PRINT 'Refund Accepted'
        END

        IF @allow = 0
        BEGIN
            UPDATE Payments
            SET
                "status" = 4
            WHERE id = @payment_id
            PRINT 'Refund Denied'
        END
    END
    ELSE
        PRINT 'Invalid Booking!'
END;

GO;

-- getAllBookingInfo()
CREATE PROCEDURE getAllBookingInfo
AS
BEGIN
    SELECT b.id, u.id as "user_id", p.id as payment_id, 
    ('Check-in: '+CAST(b."start" AS VARCHAR)+' 12:00 PM') as "in", 
    ('Check-out: '+CAST(DATEADD(DAY,1,b."end") AS VARCHAR)+' 12:00 PM') as "out", 
    r."no" as room_no,
    p.amount, DATEADD(hour, 7,p."time") as payment_time,
    c.code as coupon_code, c."value" as coupon_value,
    (u.address+', '+u.country) as "address",
    (u.title+'. '+u.last_name+', '+u.first_name) as "name",
    u.email, u.phone_num,
    dbo.getStatusCodeInfo(b."status",'bookings') as "status", 
    DATEADD(hour, 7,b."created_on") as created_on

    FROM Bookings AS b LEFT JOIN Rooms as r ON b.room_id = r.id LEFT JOIN Users as u ON b.user_id = u.id LEFT JOIN Payments as p ON b.payment_id = p.id LEFT JOIN Coupons as c ON b.coupon_id = c.id 
END;

GO;

-- getAllUserBookingInfo()
CREATE PROCEDURE getAllUserBookingInfo
    @user_id UNIQUEIDENTIFIER
AS
BEGIN
    SELECT b.id, u.id as "user_id", p.id as payment_id, 
    ('Check-in: '+CAST(b."start" AS VARCHAR)+' 12:00 PM') as "in", 
    ('Check-out: '+CAST(DATEADD(DAY,1,b."end") AS VARCHAR)+' 12:00 PM') as "out", 
    r."no" as room_no,
    p.amount, DATEADD(hour, 7,p."time") as payment_time,
    c.code as coupon_code, c."value" as coupon_value,
    (u.address+', '+u.country) as "address",
    (u.title+'. '+u.last_name+', '+u.first_name) as "name",
    u.email, u.phone_num,
    dbo.getStatusCodeInfo(b."status",'bookings') as "status", 
    DATEADD(hour, 7,b."created_on") as created_on

    FROM Bookings AS b LEFT JOIN Rooms as r ON b.room_id = r.id LEFT JOIN Users as u ON b.user_id = u.id LEFT JOIN Payments as p ON b.payment_id = p.id LEFT JOIN Coupons as c ON b.coupon_id = c.id WHERE b.user_id = @user_id;
END;

GO;

-- getPendingCancelList()
CREATE PROCEDURE getPendingCancelList
AS
BEGIN
    SELECT b.id, p.id AS payment_id, b.user_id, b.room_id, p.amount, b."start", DATEADD(day,1,b."end") AS "end", u.email, u.phone_num, u.title, u.first_name, u.last_name FROM Bookings AS b INNER JOIN Payments AS p ON b.payment_id = p.id INNER JOIN Users as u ON b.user_id = u.id WHERE p."status" = 2
END;

GO

-- getSalesInfo()
CREATE PROCEDURE getSalesInfo
    @start DATE, 
    @end DATE
AS
BEGIN
    SELECT SUM(amount) AS TotalSales, COUNT(amount) AS "count" FROM Payments WHERE ("status" = 1 OR "status" = 4) AND "time" >= @start AND "time" <= @end;
END;