# Database System Final Project

## Notes
- Time in database are stored in UTC+0
- But the interaction using procedures are using UTC+7

### Booking date recorded in the table follow these rule
- Example: 9-Jan-2021 12pm until 10-Jan-2021 12pm will be recorded as start(2020-01-9), end(2020-01-9) (because it was count as 1 night stay)
- Example: 9-Jan-2021 12pm until 12-Jan-2021 12pm will be recorded as start(2020-01-9), end(2020-01-11) (because it was count as 3 night stay)

## To Do PROCEDURE & FUNCTION & TRIGGER
- [x] Book a Room
- [x] Calculate Booking Price
- [x] Generate Payment (Trigger)
- [x] Create Coupon
- [x] Check Wanted Room Availability
- [x] Get All Room Available (on date range)
- [x] Request Cancellation
- [x] Change payment status to request refund (When cancel triggered)
- [x] Accept Refund 
- [x] Change booking status to cancel success (When refund accepted triggered)
- [x] Deny Refund 
- [x] Change booking status to cancel denied (When refund denied triggered)
- [x] Confirm Payment
- [x] Check Coupon
- [x] Hash and Verify Password
- [x] Create Account
- [x] Check In

## To Do SELECT
- [x] Get Booking Price Info
- [x] Get All Booking Info
- [x] Get a User All Booking Info
- [x] Get a Booking Info
- [x] Get Pending Cancel List
- [x] Get Sales Info (can select date range)

## Status Code
### "Bookings" Table
- 0 : Waiting payment
- 1 : Success
- 2 : Request Cancel
- 3 : Cancel Success
- 4 : Cancel Denied
- 5 : Failed

### "Payments" Table
- 0 : Waiting payment
- 1 : Success
- 2 : Request Refund
- 3 : Refund Success
- 4 : Refund Denied
- 5 : Failed

## Main File (execute in order)
- init.sql - Data Definition Languange (DDL)
- function.sql - Create SQL Stored Functions
- procedure.sql - Create SQL Stored Procedures
- trigger.sql - Create SQL Triggers

## seed.sql
- Contain initial dummy data to start demo/testing/development of this project.

## demo.sql
- Piles of examples for procedure usage.

## scenario.sql
- Contain sql in order for demo video purpose.
- Customize user info and NIM if necessary.