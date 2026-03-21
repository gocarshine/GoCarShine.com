/*
  # Add contact information and wash type to bookings table

  1. Changes
    - Add `contact_no` (text) - Customer's phone number
    - Add `email` (text) - Customer's email address
    - Add `wash_type` (text) - Type of car wash service selected
  
  2. Notes
    - These fields are added safely using IF NOT EXISTS checks
    - All new fields are required for complete booking information
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'bookings' AND column_name = 'contact_no'
  ) THEN
    ALTER TABLE bookings ADD COLUMN contact_no text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'bookings' AND column_name = 'email'
  ) THEN
    ALTER TABLE bookings ADD COLUMN email text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'bookings' AND column_name = 'wash_type'
  ) THEN
    ALTER TABLE bookings ADD COLUMN wash_type text;
  END IF;
END $$;