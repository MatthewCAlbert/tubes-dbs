-- TRIGGER

-- on insert booking
CREATE TRIGGER generatePayment
    ON Bookings
    AFTER INSERT
AS
BEGIN
    DECLARE @p_id UNIQUEIDENTIFIER = NEWID();
    INSERT INTO Payments(id, amount, method, "status", "time")
    VALUES
    (
        @p_id,
        dbo.getRoomPrice(INSERTED.room_id, INSERTED."start",INSERTED."end", INSERTED.coupon_id),
        "transfer",
        0,
        getutcdate()
    );
    UPDATE Bookings SET payment_id = @p_id WHERE id = INSERTED.id;
END;