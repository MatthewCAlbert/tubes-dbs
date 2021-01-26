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


EXEC createAccount @email='klein.rico@gmail.com', @password='wsNFH6wd', @title='Mr', @first_name='Rico', @last_name='Klein', @address='4626  Washington Avenue', @country='United States', @phone_num='(870) 572-9510', @birth_date='1996-12-01';

EXEC createAccount @email='klein.ddoogami@gmail.com', @password='wsNFH6wddas', @title='Mr', @first_name='Rico', @last_name='Bucher', @address='320 KfC', @country='Indonesia', @phone_num='+62 8111', @birth_date='1993-12-01';


INSERT INTO Coupons VALUES
    (NEWID(),'APP15','2021-01-04 00:00:00','2021-01-29 00:00:00',3,20000),
    (NEWID(),'CHEAP01','2021-01-05 00:00:00','2021-01-06 00:00:00',1,100000),
    (NEWID(),'BOOK14','2021-01-15 12:00:00','2021-01-16 00:00:00',1,50000);