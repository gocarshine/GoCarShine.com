/*
  # Fix Bookings Insert Policy

  1. Changes
    - Drop the conflicting "Users can insert own bookings" policy
    - Keep "Anyone can submit bookings" policy for unauthenticated users
    - Add a new policy for authenticated users to insert bookings
    
  2. Security
    - Anonymous users can create bookings (for public booking form)
    - Authenticated users can create bookings
    - The policy is permissive to allow both scenarios
*/

-- Drop the existing conflicting policy
DROP POLICY IF EXISTS "Users can insert own bookings" ON bookings;

-- Create a new policy that allows authenticated users to insert bookings
-- This will work alongside the "Anyone can submit bookings" policy
CREATE POLICY "Authenticated users can insert bookings"
  ON bookings
  FOR INSERT
  TO authenticated
  WITH CHECK (true);
