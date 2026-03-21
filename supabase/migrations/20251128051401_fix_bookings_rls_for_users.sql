/*
  # Fix Bookings RLS Policy for Regular Users

  1. Changes
    - Drop and recreate the "Users can view own bookings" policy with a simplified approach
    - Remove unnecessary type casting that might cause comparison issues
    - Ensure the policy properly matches bookings.email with auth.users.email
    
  2. Security
    - Users can only view bookings where the email matches their authenticated email
    - Admins can still view all bookings
    - No change to insert/update/delete policies
*/

-- Drop the existing policy
DROP POLICY IF EXISTS "Users can view own bookings" ON bookings;

-- Recreate with simplified comparison
CREATE POLICY "Users can view own bookings"
  ON bookings
  FOR SELECT
  TO authenticated
  USING (
    bookings.email = (SELECT auth.users.email FROM auth.users WHERE auth.users.id = auth.uid())
  );
