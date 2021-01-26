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

INSERT INTO Users VALUES
    (1,'klein.rico@gmail.com','wsNFH6wd','M','Rico','Klein','4626 Washington Avenue','United States','(870) 572-9510','1998-02-12 00:00:00',NULL),
    (2,'mcgrath_awesome@gmail.com','xqNbFcUb','F','Della','McGrath','576 Retreat Avenue','United States','(916) 485-1279','30/11/1998',NULL),
    (3,'clay_funny_khloe@yahoo.co.id','gaFu9mTf','M','Khloe','Clay','673 Leo Street','United States','(972) 347-9049','13/09/1998',NULL),
    (4,'jerome_cobbzs1@outlook.com','ujbEn5LN','M','Jerome','Cobb','217 Jane St West Helena, Arkansas(AR), 72390','United States','(301) 290-1443','1978-10-10 00:00:00',NULL),
    (5,'fritzbby_Niko@gmail.com','TdKHgAsC','M','Niko','Fritz','1802 Grey Ave Evanston, Illinois(IL), 60201','United States','(765) 932-2732','2001-01-01 00:00:00',NULL),
    (6,'wallaby102@yahoo.com','Mqkln2j2l','M','Paul','Wallaby','1 Wilmott St','United Kingdom','(456) 667-8923','1990-02-12 00:00:00',NULL),
    (7,'Marsten_loop@yahoo.com','dfLmaA9Q','M','John','Marten','3 St Margaret St','United Kingdom','(901) 889-2850','13/03/1988',NULL),
    (8,'master.yoda@yahoo.com','ADgdhen0','M','Yondu','Yoda','Westminster','United Kingdom','(902) 764-9022','2001-11-08 00:00:00',NULL),
    (9,'cika_alba@yahoo.com','1danILM','F','Jessica','Alba','2-14 Myddleton St','United Kingdom','(782) 110-2920','19/05/2002',NULL),
    (10,'aquaspace7@yahoo.com','7H7JJkml','F','Vannesa','Bigs','Aglionby St','United Kingdom','(782) 098-2222','20/06/2002',NULL);

INSERT INTO Payments VALUES
    (1,150000,'Credit Card','Success','2021-01-05 09:31:59'),
    (2,1000000,'Debit Card','Waiting','2021-01-11 20:27:12'),
    (3,250000,'Credit Card','Failed','2021-01-10 14:18:56'),
    (4,350000,'Debit Card','Success','2021-01-06 07:18:12'),
    (5,265000,'Debit Card','Success','2021-01-01 23:09:49');

INSERT INTO Coupons VALUES
    (NEWID(),'APP15','2021-01-04 00:00:00','2021-01-29 00:00:00',3,20000),
    (NEWID(),'CHEAP01','2021-01-05 00:00:00','2021-01-06 00:00:00',1,100000),
    (NEWID(),'BOOK14','2021-01-15 12:00:00','2021-01-16 00:00:00',1,50000);

INSERT INTO Bookings VALUES
    (101,4,11,1,NULL,'2021-01-26 10:08:27','2021-01-29 19:15:55','Success','2021-01-26 12:00:31'),
    (102,5,12,2,222,'2021-01-25 02:40:14','2021-01-25 13:40:14','Success','2021-01-24 13:40:14'),
    (103,7,13,3,NULL,'2021-01-17 01:33:25','2021-01-30 12:51:25','Failed','2021-01-16 20:33:25'),
    (104,9,14,4,NULL,'2021-01-16 02:19:09','2021-01-21 14:48:54','Request Cancel','2021-01-15 21:19:09'),
    (105,10,15,5,111,'2021-01-20 07:10:31','2021-01-24 08:02:56','Success','2021-01-20 02:02:56');
