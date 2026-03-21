/*
  # Add car parking number to bookings table

  1. Changes
    - Add `car_parking_number` column to store optional parking location
  
  2. Column Details
    - `car_parking_number` (text, nullable) - Optional field for parking location (e.g., "Basement B2 – P14")
  
  3. Notes
    - This field is optional and can be left empty
    - No default value needed as it's nullable
*/

-- Add car_parking_number column
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'bookings' AND column_name = 'car_parking_number'
  ) THEN
    ALTER TABLE bookings ADD COLUMN car_parking_number text;
  END IF;
END $$;