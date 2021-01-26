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
    @uid UNIQUEIDENTIFIER, 
    @room_id INT, 
    @start DATE, 
    @end DATE, 
    @coupon_code VARCHAR(32) = NULL
AS
BEGIN
    DECLARE @c_id UNIQUEIDENTIFIER = dbo.checkCoupon(@coupon_code);

    IF @c_id = NULL
    BEGIN
        PRINT 'Coupon not valid!';
        RETURN;
    END

    IF (SELECT COUNT(*) FROM Rooms AS r
        INNER JOIN Bookings AS b ON r.id = b.room_id 
        WHERE (@start BETWEEN b."start" AND b."end") OR (@end BETWEEN b."start" AND b."end") ) < 1
        BEGIN
            INSERT INTO Bookings(id, user_id, room_id, payment_id, coupon_id, "start", "end", "status") 
            VALUES (NEWID(), @uid, @room_id, NULL, @c_id, @start, @end, 0);
            SELECT 'Success';
        END
    ELSE
        SELECT 'Failed';
END;

GO;

-- checkAvailability()
CREATE PROCEDURE checkAvailability
    @start DATE, 
    @end DATE, 
    @roomtype_id UNIQUEIDENTIFIER = NULL
AS
BEGIN
    IF @roomtype_id = NULL
        BEGIN
            SELECT b."start", b."end" FROM Rooms AS r
            INNER JOIN Bookings AS b ON r.id = b.room_id 
            WHERE (@start BETWEEN b."start" AND b."end") OR (@end BETWEEN b."start" AND b."end")
            SELECT COUNT(*) FROM Rooms AS r WHERE r.roomtype_id = @roomtype_id;
        END
    ELSE
        SELECT 'Failed';
END;