-- TRIGGER

-- on insert booking
CREATE TRIGGER generatePayment
    ON Bookings
    AFTER INSERT
AS
BEGIN
    DECLARE @p_id UNIQUEIDENTIFIER = NEWID();
    DECLARE @c_value NUMERIC = 0;
    DECLARE @amount NUMERIC = ( 
        SELECT DATEDIFF(day, INSERTED."end",INSERTED."start")*t.price 
        FROM Rooms as r INNER JOIN RoomTypes as t ON r.roomtype_id = t.id 
        );
    IF INSERTED.coupon_id != NULL AND
    (SELECT COUNT(*) FROM Bookings WHERE coupon_id = INSERTED.coupon_id) < 1
    SET @c_value  = (
        SELECT "value" FROM Coupons
        WHERE id = INSERTED.coupon_id AND getutcdate() >= valid_from AND getutcdate() <= expired_on
    );
    INSERT INTO Payments(id, amount, method, "status", "time")
    VALUES
    (
        @p_id,
        @amount-@c_value,
        NULL,
        0,
        getutcdate()
    );
    UPDATE Bookings SET payment_id = @p_id WHERE id = INSERTED.id;
END;