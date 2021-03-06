-- Functions

CREATE FUNCTION hashPassword
    (@password VARCHAR(64))
RETURNS VARBINARY(8000)
AS
BEGIN
    DECLARE @hashed_password VARBINARY(8000) = hashbytes('MD5', @password);
    RETURN @hashed_password;
END;

GO

CREATE FUNCTION verifyPassword
    (@password VARCHAR(64), @hashed_password VARBINARY(8000))
RETURNS INT
AS
BEGIN
    DECLARE @ok INT = 0;
    IF hashbytes('MD5', @password) = convert(varbinary(max),@hashed_password,1)
        SET @ok = 1;
	RETURN @ok;
END;

GO
    
CREATE FUNCTION checkCoupon
    (@coupon_code VARCHAR(32))
RETURNS UNIQUEIDENTIFIER
AS
BEGIN
    DECLARE @ok UNIQUEIDENTIFIER = NULL;
    DECLARE @found_coupon TABLE (id UNIQUEIDENTIFIER, quota INT);

    INSERT INTO @found_coupon SELECT id,quota FROM Coupons WHERE code = @coupon_code AND getutcdate() >= valid_from AND getutcdate() <= expired_on;

    IF (SELECT COUNT(*) FROM @found_coupon) > 0 AND (SELECT COUNT(*) FROM Bookings WHERE coupon_id = (SELECT id FROM @found_coupon) ) < (SELECT quota FROM @found_coupon)
        SET @ok = (SELECT id FROM @found_coupon);
	RETURN @ok;
END;

GO

CREATE FUNCTION checkRoomAvailable
    (@room_id INT, @start DATE, @end DATE)
RETURNS INT
AS
BEGIN
    IF (SELECT COUNT(*) FROM Rooms AS r
        INNER JOIN Bookings AS b ON r.id = b.room_id 
        WHERE ((@start BETWEEN b."start" AND b."end") OR (@end BETWEEN b."start" AND b."end")) AND (b."status" != 3 AND b."status" != 5) AND b.room_id = @room_id) < 1
        RETURN 1;
    RETURN 0;
END;

GO

CREATE FUNCTION getRoomPrice
    (@roomtype_id INT = NULL, @room_id INT = NULL, @start DATE, @end DATE, @coupon_id UNIQUEIDENTIFIER = NULL)
RETURNS NUMERIC
AS
BEGIN
    DECLARE @c_value NUMERIC = 0;
    DECLARE @amount NUMERIC;

    IF @roomtype_id IS NULL
        SET @amount = ( 
            SELECT (DATEDIFF(day, @start,@end)+1)*t.price 
            FROM Rooms as r INNER JOIN RoomTypes as t ON r.roomtype_id = t.id 
            WHERE r.id = @room_id);
    ELSE
        SET @amount = ( 
            SELECT (DATEDIFF(day, @start,@end)+1)*price 
            FROM RoomTypes WHERE id = @roomtype_id);

    IF @coupon_id IS NOT NULL AND (SELECT COUNT(*) FROM Coupons WHERE id = @coupon_id) > 0
    SET @c_value  = (
        SELECT "value" FROM Coupons
        WHERE id = @coupon_id
    );
    IF @amount-@c_value < 0
        RETURN 0;
    RETURN @amount-@c_value;
END;

GO

CREATE FUNCTION getStatusCodeInfo
    (@code INT, @typ VARCHAR(12))
RETURNS VARCHAR(32)
AS
BEGIN
    IF @typ = 'bookings'
    RETURN 
        CASE 
            WHEN @code = 0 THEN 'Waiting Payment'
            WHEN @code = 1 THEN 'Success'
            WHEN @code = 2 THEN 'Request Cancel'
            WHEN @code = 3 THEN 'Cancel Success'
            WHEN @code = 4 THEN 'Cancel Denied'
            WHEN @code = 5 THEN 'Failed'
        END;
    IF @typ = 'payments'
    RETURN
        CASE 
            WHEN @code = 0 THEN 'Waiting Payment'
            WHEN @code = 1 THEN 'Success'
            WHEN @code = 2 THEN 'Request Refund'
            WHEN @code = 3 THEN 'Refund Success'
            WHEN @code = 4 THEN 'Refund Denied'
            WHEN @code = 5 THEN 'Failed'
        END;
    RETURN NULL;
END;

GO