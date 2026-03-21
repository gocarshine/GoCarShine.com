/*
  # Add payment reference field to bookings

  1. Changes
    - Add `payment_reference` column to `bookings` table
      - Type: text (nullable)
      - Used to store payment transaction IDs or reference numbers
  
  2. Notes
    - Field is optional as existing bookings may not have payment references
    - Can be used to track payment confirmations and reconciliation
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'bookings' AND column_name = 'payment_reference'
  ) THEN
    ALTER TABLE bookings ADD COLUMN payment_reference text;
  END IF;
END $$;