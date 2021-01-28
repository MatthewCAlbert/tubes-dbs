# Tugas Matkul Database System

## Notes
- Time in database are stored in UTC+0
- But the interaction using procedures are using UTC+7

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
- [ ] Get Booking Price Info
- [ ] Get a User All Booking Info
- [x] Get a Booking Info
- [ ] Get Pending Cancel List
- [ ] Get All Booking Info
- [ ] Get Sales Info (can select date range)

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

## seed.sql
- Contain initial dummy data to start demo of this project