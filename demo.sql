SELECT dbo.verifyPassword('wsNFH6wd', password) AS result FROM Users WHERE email = 'klein.rico@gmail.com';

SELECT dbo.checkCoupon('APP15')

SELECT * FROM Users;

EXEC bookRoom
@user_id = 'F413CB31-568A-4DB4-89FD-288C363B252C',
@room_id = 8,
@start = '2020-12-01',
@end = '2020-12-03',
@coupon_code = NULL;

EXEC bookRoom
@user_id = 'F413CB31-568A-4DB4-89FD-288C363B252C',
@room_id = 9,
@start = '2021-02-20',
@end = '2021-02-23',
@coupon_code = 'APP15';

SELECT * FROM Bookings;

SELECT dbo.checkRoomAvailable(8, '2020-12-01','2020-12-02')

EXEC getAvailableRoom
@start = '2021-02-20',
@end = '2021-02-23',
@roomtype_id = 6

SELECT dbo.getRoomPrice(8, '2020-12-01','2020-12-02', '07FC88B1-674A-4AB9-BCF2-9C3B46F953BD')

EXEC createCoupon
    @code = 'TUGASDB', 
    @valid_from = '2021-01-01',
    @expired_on = '2021-02-02',
    @quota = 1,
    @value = 10000

SELECT * FROM Coupons;

EXEC checkIn
	@booking_id = 'DA65A3E8-A377-4DE3-AC73-992FA608C3BB';

EXEC getBooking
    @booking_id = '8C09651C-3B07-49A1-AAB4-654EB91E5503'

EXEC confirmPayment
	@payment_id = '83D51A8F-689C-4605-AA29-FA9DB4D9831C'

EXEC respondCancellation
	@payment_id = '2C263A26-FD85-4BA8-A346-C775CE8D116E',
	@allow = 1

EXEC forceChangePassword
	@user_id = 'F413CB31-568A-4DB4-89FD-288C363B252C',
    @new_password = '12345'

EXEC changePassword
	@user_id = 'F413CB31-568A-4DB4-89FD-288C363B252C',
	@old_password = '12345',
    @new_password = '123456'

EXEC getPendingCancelList

EXEC requestCancel
	@booking_id = 'F9A1AE20-4B4B-4A49-B339-3B59B5A81CCA'

EXEC editAccountInfo
	@id = 'F413CB31-568A-4DB4-89FD-288C363B252C',
    @title = NULL,
    @first_name = NULL,
    @last_name  = NULL,
    @address  = NULL,
    @country = NULL,
    @phone_num  = NULL,
    @birth_date = NULL

SELECT * FROM Users;