/*
  # Add Car Details to Bookings Table

  1. Changes
    - Add `license_plate` column to store car license plate number
    - Add `car_model` column to store car model/make
    - Add `additional_info` column to store any additional information from customer
  
  2. Columns
    - All columns are nullable to allow flexibility
    - text data type for all new fields
    - Default empty string for additional_info to avoid null handling
*/

-- Add license plate column
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'bookings' AND column_name = 'license_plate'
  ) THEN
    ALTER TABLE bookings ADD COLUMN license_plate text;
  END IF;
END $$;

-- Add car model column
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'bookings' AND column_name = 'car_model'
  ) THEN
    ALTER TABLE bookings ADD COLUMN car_model text;
  END IF;
END $$;

-- Add additional info column
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'bookings' AND column_name = 'additional_info'
  ) THEN
    ALTER TABLE bookings ADD COLUMN additional_info text DEFAULT '';
  END IF;
END $$;
