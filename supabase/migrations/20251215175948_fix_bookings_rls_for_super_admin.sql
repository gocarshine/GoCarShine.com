/*
  # Fix Bookings RLS Policies for Super Admin Access

  ## Problem
  The SELECT and DELETE policies on bookings table only check for 'admin' role,
  not 'super_admin' role. This prevents super admins from viewing and managing
  all bookings in the admin dashboard.

  ## Solution
  Update the policies to check for both 'admin' and 'super_admin' roles using
  the get_current_user_role() function to avoid RLS recursion issues.

  ## Changes
  - Drop existing admin-related SELECT and DELETE policies
  - Create new policies that include both admin and super_admin roles
  - Use get_current_user_role() function for consistency and to avoid recursion
*/

-- Drop existing policies that need to be updated
DROP POLICY IF EXISTS "Admins can view all bookings" ON bookings;
DROP POLICY IF EXISTS "Admins can delete bookings" ON bookings;
DROP POLICY IF EXISTS "Admins can update all bookings" ON bookings;

-- Create new SELECT policy that allows both admins and super admins to view all bookings
CREATE POLICY "Admins and super admins can view all bookings"
  ON bookings
  FOR SELECT
  TO authenticated
  USING (
    email = auth.email()
    OR get_current_user_role() IN ('admin', 'super_admin')
  );

-- Create new UPDATE policy that allows both admins and super admins to update all bookings
CREATE POLICY "Admins and super admins can update all bookings"
  ON bookings
  FOR UPDATE
  TO authenticated
  USING (get_current_user_role() IN ('admin', 'super_admin'))
  WITH CHECK (get_current_user_role() IN ('admin', 'super_admin'));

-- Create new DELETE policy that allows both admins and super admins to delete bookings
CREATE POLICY "Admins and super admins can delete bookings"
  ON bookings
  FOR DELETE
  TO authenticated
  USING (get_current_user_role() IN ('admin', 'super_admin'));