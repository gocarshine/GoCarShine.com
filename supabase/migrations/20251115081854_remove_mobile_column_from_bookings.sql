/*
  # Remove mobile column from bookings table

  1. Changes
    - Drop the `mobile` column from bookings table

  2. Notes
    - This is a safe operation as we're only removing a column
    - The contact_no column remains for contact information
*/

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'bookings' AND column_name = 'mobile'
  ) THEN
    ALTER TABLE bookings DROP COLUMN mobile;
  END IF;
END $$;