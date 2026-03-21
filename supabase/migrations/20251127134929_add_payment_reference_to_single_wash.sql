/*
  # Add payment reference field to single_wash_bookings

  1. Changes
    - Add `payment_reference` column to `single_wash_bookings` table
      - Type: text (nullable)
      - Used to store payment transaction IDs or reference numbers
  
  2. Notes
    - Field is optional as existing bookings may not have payment references
    - Can be used to track payment confirmations and reconciliation
    - Admins can add/edit payment references for bookings
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'single_wash_bookings' AND column_name = 'payment_reference'
  ) THEN
    ALTER TABLE single_wash_bookings ADD COLUMN payment_reference text;
  END IF;
END $$;