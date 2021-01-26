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