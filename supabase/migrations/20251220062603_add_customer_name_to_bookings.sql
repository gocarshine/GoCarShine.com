/*
  # Add customer_name column to bookings table

  1. Changes
    - Add `customer_name` column to the `bookings` table
    - Type: text (nullable to maintain compatibility with existing data)
    - This will store the customer's full name for package bookings

  2. Notes
    - Column is nullable to allow existing bookings without breaking
    - New bookings should include the customer name going forward
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'bookings' AND column_name = 'customer_name'
  ) THEN
    ALTER TABLE bookings ADD COLUMN customer_name text;
  END IF;
END $$;