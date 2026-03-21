/*
  # Fix Ambiguous Email Column Reference
  
  1. Changes
    - Drop the existing "Users can view own bookings" policy that has an ambiguous email reference
    - Recreate the policy with explicit table qualification (bookings.email)
    
  2. Security
    - Maintains the same security model: users can only view bookings with their email address
    - No change to access control logic
*/

-- Drop the policy with ambiguous email reference
DROP POLICY IF EXISTS "Users can view own bookings" ON bookings;

-- Recreate policy with explicit table qualification
CREATE POLICY "Users can view own bookings"
  ON bookings
  FOR SELECT
  TO authenticated
  USING (bookings.email = (SELECT email FROM auth.users WHERE id = auth.uid()));
