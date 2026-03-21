/*
  # Add preferred time slot to bookings

  1. Changes
    - Add `preferred_time_slot` column to bookings table to store customer's preferred service time
    - Time slots are between 5:00 AM to 11:00 AM

  2. Notes
    - This field allows customers to specify their preferred time window for service
    - The column is nullable to maintain backward compatibility with existing bookings
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'bookings' AND column_name = 'preferred_time_slot'
  ) THEN
    ALTER TABLE bookings ADD COLUMN preferred_time_slot text;
  END IF;
END $$;