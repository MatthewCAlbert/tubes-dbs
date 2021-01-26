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

-- bookRoom()
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
            INSERT INTO Bookings(id, user_id, room_id, payment_id, coupon_id, "start", "end", "status") 
            VALUES (NEWID(), @user_id, @room_id, NULL, @c_id, @start, @end, 0);
            PRINT 'Booking Success';
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
            WHERE (@start BETWEEN b."start" AND b."end") OR (@end BETWEEN b."start" AND b."end"));
        END
    ELSE
        BEGIN
            SELECT * FROM Rooms WHERE id NOT IN
            (SELECT r.id FROM Rooms AS r
            INNER JOIN Bookings AS b ON r.id = b.room_id 
            WHERE (@start BETWEEN b."start" AND b."end") OR (@end BETWEEN b."start" AND b."end")) AND roomtype_id = @roomtype_id;
        END
END;

GO;

-- createCoupon()
CREATE PROCEDURE createCoupon
    @code VARCHAR(32), 
    @valid_from DATETIME,
    @expired_on DATETIME,
    @quota INT,
    @value NUMERIC
AS
BEGIN
    IF @valid_from >= @expired_on
    BEGIN
        PRINT 'Expired must be bigger than start!';
        RETURN;
    END

    IF (SELECT COUNT(*) FROM Coupons WHERE code = @code AND (valid_from BETWEEN @valid_from AND @expired_on) AND (expired_on BETWEEN @valid_from AND @expired_on)) > 0
    BEGIN
        PRINT 'Cannot use same code with overlapped time!';
        RETURN;
    END

    INSERT INTO Coupons VALUES
        (NEWID(),@code,@valid_from,@expired_on,@quota,@value);
    PRINT 'Coupon successfully created!';
END;

GO;

--confirmPayment()

--requestRefund()

--acceptRefund()

--rejectRefund()