/*
  # Add Package Booking Columns

  1. Changes
    - Add `package_name` column to store the selected package name
    - Add `package_price` column to store the package price
    - Add `package_period` column to store the billing period (per month/quarter/year)
    - Add `car_size` column to store the selected car size (small/medium/big)
    - Add `mobile` column to store customer mobile number
    - Add `address` column to store customer address
    - Rename `contact_no` to align with new `mobile` field usage

  2. Notes
    - Existing columns `email` and `status` will be reused
    - These columns support the package selection booking flow
*/

-- Add package-related columns
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS package_name text;
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS package_price integer;
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS package_period text;
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS car_size text;
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS mobile text;
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS address text;