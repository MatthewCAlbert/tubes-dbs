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

    -- DECLARE @fcp_count INT = (SELECT COUNT(id) FROM Coupons WHERE code = @coupon_code);
    -- DECLARE @found_coupon TABLE (id UNIQUEIDENTIFIER, valid_from DATETIME, expired_on DATETIME, quota INT);
    -- DECLARE @fc_i TABLE (id UNIQUEIDENTIFIER, valid_from DATETIME, expired_on DATETIME, quota INT);

    -- INSERT INTO @found_coupon 

    -- DECLARE @i INT = 0;
    -- WHILE @i < @fcp_count
    -- BEGIN
    --     INSERT INTO @fc_i SELECT * FROM @found_coupon LIMIT @i,1;
    --     SET @i = @i + 1
    -- END;
    
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