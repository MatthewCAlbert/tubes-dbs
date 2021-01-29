-- Insert Initial Data
INSERT INTO RoomTypes VALUES
    (1,'single',150000),
    (2,'double',235000),
    (3,'triple',265000),
    (4,'quad',300000),
    (5,'queen',350000),
    (6,'king',1000000);

INSERT INTO Rooms VALUES
    (1,1,101,NULL),
    (2,1,102,NULL),
    (3,2,103,NULL),
    (4,2,104,NULL),
    (5,2,105,NULL),
    (6,3,201,NULL),
    (7,3,202,NULL),
    (8,4,203,NULL),
    (9,4,204,NULL),
    (10,5,205,NULL),
    (11,5,301,NULL),
    (12,5,302,NULL),
    (13,6,303,NULL),
    (14,6,304,NULL),
    (15,6,305,NULL);

-- create Coupon
EXEC createCoupon
    @code = 'DBS-2301848981', 
    @valid_from = '2021-01-01 00:00',
    @expired_on = '2021-02-28 00:00',
    @quota = 1,
    @value = 100000;
EXEC createCoupon
    @code = 'DBS2-2301848981', 
    @valid_from = '2021-01-01 00:00',
    @expired_on = '2021-02-28 00:00',
    @quota = 2,
    @value = 50000;

SELECT * FROM Coupons;

-- create an account
EXEC createAccount 
    @email='matthew.albert@binus.ac.id', 
    @password='test12345', 
    @title='Mr', 
    @first_name='Matthew Christopher', 
    @last_name='Albert', 
    @address='Pasir Kaliki 123', 
    @country='Indonesia', 
    @phone_num='+62 822-500-600', 
    @birth_date='2001-03-03';

SELECT * FROM Users;

-- edit an account info
EXEC editAccountInfo
	@id = 'insert_uuid_here',
    @title = NULL,
    @first_name = NULL,
    @last_name  = NULL,
    @address  = NULL,
    @country = NULL,
    @phone_num  = NULL,
    @birth_date = NULL;

SELECT * FROM Users;

-- Test Login
EXEC accountLogin
	@email = 'matthew.albert@binus.ac.id',
    @password = 'test12345';

-- Reset Password
EXEC forceChangePassword
	@user_id = 'insert_uuid_here',
    @new_password = 'test54321'

EXEC accountLogin
	@email = 'matthew.albert@binus.ac.id',
    @password = 'test54321';

-- Change Password
EXEC changePassword
	@user_id = 'insert_uuid_here',
	@old_password = 'test54321',
    @new_password = 'test12345';
    
-- Test Again

-- check available room
EXEC getAvailableRoom
    @start = '2021-02-20',
    @end = '2021-02-23',
    @roomtype_id = 3
-- change with different scenario

SELECT * FROM Rooms;

-- Book a Room
EXEC bookRoom
    @user_id = 'insert_uuid_here',
    @room_id = 8,
    @start = '2021-02-10',
    @end = '2021-02-12',
    @coupon_code = NULL;

EXEC bookRoom
    @user_id = 'insert_uuid_here',
    @room_id = 8,
    @start = '2021-02-13',
    @end = '2021-02-14',
    @coupon_code = 'DBS-2301848981';
-- test Dupe Coupon

-- test coupon with more than 1 quota
EXEC bookRoom
    @user_id = 'insert_uuid_here',
    @room_id = 6,
    @start = '2021-02-13',
    @end = '2021-02-14',
    @coupon_code = 'DBS2-2301848981';
EXEC bookRoom
    @user_id = 'insert_uuid_here',
    @room_id = 7,
    @start = '2021-02-13',
    @end = '2021-02-14',
    @coupon_code = 'DBS2-2301848981';
-- test third Coupon

-- Get All Bookings
EXEC getAllBookingInfo;

-- Get All Bookings of a user
EXEC getAllUserBookingInfo
    @user_id = 'insert_uuid_here';

-- Get Booking
EXEC getBooking
    @booking_id = 'insert_booking_id_here';
EXEC getBooking
    @booking_id = 'insert_booking_id_here';
EXEC getBooking
    @booking_id = 'insert_booking_id_here';

-- Pay Booking Payment
EXEC confirmPayment
	@payment_id = 'insert_payment_id_here';
EXEC confirmPayment
	@payment_id = 'insert_payment_id_here';
EXEC confirmPayment
	@payment_id = 'insert_payment_id_here';

-- Cancel Two Booking
EXEC requestCancel
	@booking_id = 'insert_booking_id_here';
EXEC requestCancel
	@booking_id = 'insert_booking_id_here';
-- Try cancel on unpaid one
EXEC requestCancel
	@booking_id = 'insert_booking_id_here';

EXEC getAllBookingInfo;

-- Get All Cancel Request
EXEC getPendingCancelList;

-- Accept One Cancel Request
EXEC respondCancellation
	@payment_id = 'insert_payment_id_here',
	@allow = 1;

-- Reject One Cancel Request
EXEC respondCancellation
	@payment_id = 'insert_payment_id_here',
	@allow = 0;

EXEC getAllBookingInfo;

-- Try Check In on Paid
EXEC checkIn
	@booking_id = 'insert_booking_id_here';

-- Try Check In on Unpaid
EXEC checkIn
	@booking_id = 'insert_booking_id_here';

-- Try Check In on Refunded
EXEC checkIn
	@booking_id = 'insert_booking_id_here';

-- Try Check In on Refund Rejected
EXEC checkIn
	@booking_id = 'insert_booking_id_here';

-- Get Sales Info
EXEC getSalesInfo;

EXEC getSalesInfo
    @start = '2020-01-01', 
    @end = '2020-02-01';