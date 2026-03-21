/*
  # Allow Single Wash Bookings Without Login

  1. Changes
    - Make `user_id` nullable in `single_wash_bookings` table to allow bookings without login
    - Add policy to allow anonymous users to insert bookings
    - Keep existing policies for authenticated users and admins

  2. Security
    - Anonymous users can only insert bookings (no read/update/delete)
    - Authenticated users can still view and manage their own bookings
    - Admins can still manage all bookings
*/

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'single_wash_bookings' AND column_name = 'user_id'
  ) THEN
    ALTER TABLE single_wash_bookings ALTER COLUMN user_id DROP NOT NULL;
  END IF;
END $$;

CREATE POLICY "Allow anonymous users to insert single wash bookings"
  ON single_wash_bookings FOR INSERT
  TO anon
  WITH CHECK (true);