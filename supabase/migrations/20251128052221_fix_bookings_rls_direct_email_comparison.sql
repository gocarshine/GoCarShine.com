/*
  # Fix Bookings RLS - Direct Email Comparison

  1. Problem
    - Users cannot see their own bookings even when email matches
    - The subquery in USING clause may not be working correctly in RLS context
    
  2. Solution
    - Use auth.email() helper function for direct comparison
    - This is the recommended Supabase approach for email-based RLS
    
  3. Security
    - Users can only view bookings where email matches their authenticated email
    - Admins can still view all bookings via separate policy
*/

-- Drop the problematic policy
DROP POLICY IF EXISTS "Users can view own bookings" ON bookings;

-- Create policy using auth.email() for direct comparison
CREATE POLICY "Users can view own bookings"
  ON bookings
  FOR SELECT
  TO authenticated
  USING (bookings.email = auth.email());
