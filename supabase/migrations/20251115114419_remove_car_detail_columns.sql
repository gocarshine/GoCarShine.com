/*
  # Remove Car Detail Columns from Bookings Table

  1. Changes
    - Remove `license_plate` column
    - Remove `car_model` column  
    - Remove `additional_info` column
  
  2. Notes
    - Reverting the car details feature
    - These columns are safe to drop as they were just added
*/

-- Remove license_plate column
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'bookings' AND column_name = 'license_plate'
  ) THEN
    ALTER TABLE bookings DROP COLUMN license_plate;
  END IF;
END $$;

-- Remove car_model column
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'bookings' AND column_name = 'car_model'
  ) THEN
    ALTER TABLE bookings DROP COLUMN car_model;
  END IF;
END $$;

-- Remove additional_info column
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'bookings' AND column_name = 'additional_info'
  ) THEN
    ALTER TABLE bookings DROP COLUMN additional_info;
  END IF;
END $$;
