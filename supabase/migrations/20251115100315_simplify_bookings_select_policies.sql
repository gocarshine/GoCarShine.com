/*
  # Simplify Bookings SELECT Policies

  1. Changes
    - Drop redundant SELECT policies
    - Keep only essential policies:
      - Admins can view all bookings
      - Regular users can view their own bookings
    
  2. Security
    - Admins (users with 'admin' role in user_roles table) can see ALL bookings
    - Regular authenticated users can only see bookings with their email
    - Anonymous users cannot view bookings
*/

-- Drop all existing SELECT policies
DROP POLICY IF EXISTS "Admins can view all bookings" ON bookings;
DROP POLICY IF EXISTS "Authenticated users can view bookings" ON bookings;
DROP POLICY IF EXISTS "Users can view own bookings" ON bookings;

-- Create policy for admins to view all bookings
CREATE POLICY "Admins can view all bookings"
  ON bookings
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM user_roles
      WHERE user_roles.user_id = auth.uid() 
      AND user_roles.role = 'admin'
    )
  );

-- Create policy for regular users to view their own bookings
CREATE POLICY "Users can view own bookings"
  ON bookings
  FOR SELECT
  TO authenticated
  USING (email = (SELECT email FROM auth.users WHERE id = auth.uid()));
