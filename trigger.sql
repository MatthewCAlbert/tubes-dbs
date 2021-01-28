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
        dbo.getRoomPrice((SELECT room_id FROM INSERTED), (SELECT "start" FROM INSERTED),(SELECT "end" FROM INSERTED), (SELECT coupon_id FROM INSERTED)),
        'transfer',
        0,
        NULL
    );
    UPDATE Bookings SET payment_id = @p_id, created_on = getutcdate() WHERE id = (SELECT id FROM INSERTED);
END;

GO

-- On Payment UPDATE (update book to cancel / deny)
CREATE TRIGGER reactToCancelRespond
    ON Payments
    AFTER UPDATE
AS
BEGIN
    DECLARE @b_id UNIQUEIDENTIFIER = (SELECT id FROM Bookings WHERE payment_id = (SELECT id FROM INSERTED));
    IF (SELECT "status" FROM INSERTED) = 3
        UPDATE Bookings SET "status" = 3 WHERE id = @b_id;
    IF (SELECT "status" FROM INSERTED) = 4
        UPDATE Bookings SET "status" = 4 WHERE id = @b_id;
END;

GO

-- On Booking UPDATE (update payment to request refund)
CREATE TRIGGER reactToCancelRequest
    ON Bookings
    AFTER UPDATE
AS
BEGIN
    IF (SELECT "status" FROM INSERTED) = 2
        UPDATE Payments SET "status" = 2 WHERE id = (SELECT payment_id FROM INSERTED);
END;

GO

-- on delete Booking
CREATE TRIGGER onDeleteBooking
    ON Bookings
    AFTER DELETE
AS
BEGIN
    DELETE Payments WHERE id = (SELECT payment_id FROM DELETED);
END;