# Tugas Database Matkul System

## To Do PROCEDURE & FUNCTION & TRIGGER
- [ ] Book a Room
- [ ] Generate Payment (Trigger)
- [ ] Get Room Availability (can select date range too) + Check Wanted Room Availability
- [ ] Request Cancellation
- [ ] Change payment status to request refund (When cancel triggered)
- [ ] Accept Refund 
- [ ] Change booking status to cancel success (When refund accepted triggered)
- [ ] Deny Refund 
- [ ] Change booking status to cancel denied (When refund denied triggered)
- [ ] Confirm Payment
- [ ] Increment Rooms Id and RoomTypes Id (INT)
- [x] Check Coupon
- [x] Hash and Verify Password
- [x] Create Account

## To Do SELECT
- [ ] Get Price Info
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

### "Bookings" Table
- 0 : Waiting payment
- 1 : Success
- 2 : Request Refund
- 3 : Refund Success
- 4 : Refund Denied
- 5 : Failed

## seed.sql
- Contain initial dummy data to start demo of this project