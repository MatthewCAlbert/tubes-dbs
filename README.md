# Tugas Matkul Database System

## To Do PROCEDURE & FUNCTION & TRIGGER
- [x] Book a Room
- [x] Calculate Booking Price
- [ ] Generate Payment (Trigger)
- [x] Create Coupon
- [x] Check Wanted Room Availability
- [x] Get All Room Available (on date range)
- [ ] Request Cancellation
- [ ] Change payment status to request refund (When cancel triggered)
- [ ] Accept Refund 
- [ ] Change booking status to cancel success (When refund accepted triggered)
- [ ] Deny Refund 
- [ ] Change booking status to cancel denied (When refund denied triggered)
- [ ] Confirm Payment
- [x] Check Coupon
- [x] Hash and Verify Password
- [x] Create Account

## To Do SELECT
- [ ] Get Booking Price Info
- [ ] Get a User All Booking Info
- [ ] Get a Booking Info
- [ ] Get All Booking Info
- [ ] Get sales info (can select date range)

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