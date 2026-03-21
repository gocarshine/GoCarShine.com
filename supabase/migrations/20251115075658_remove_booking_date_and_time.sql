/*
  # Remove booking date and time columns

  1. Changes
    - Drop `booking_date` column from bookings table
    - Drop `booking_time` column from bookings table

  2. Notes
    - These columns are not needed for package bookings
    - The created_at timestamp is sufficient for tracking when bookings were made
*/

ALTER TABLE bookings DROP COLUMN IF EXISTS booking_date;
ALTER TABLE bookings DROP COLUMN IF EXISTS booking_time;