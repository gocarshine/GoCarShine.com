/*
  # Fix Single Wash Bookings RLS for Super Admin

  ## Problem
  The single_wash_bookings table policies only check for 'admin' role, 
  not 'super_admin'. This prevents super admins from viewing and managing 
  single wash bookings in the admin panel.

  ## Solution
  Update all admin policies to use the is_admin() function, which now 
  includes both 'admin' and 'super_admin' roles.

  ## Changes
  - Drop existing admin policies
  - Recreate them using is_admin() function for consistency
*/

-- Drop existing admin policies
DROP POLICY IF EXISTS "Admins can view all single wash bookings" ON single_wash_bookings;
DROP POLICY IF EXISTS "Admins can update all single wash bookings" ON single_wash_bookings;
DROP POLICY IF EXISTS "Admins can delete single wash bookings" ON single_wash_bookings;

-- Recreate policies using is_admin() function
CREATE POLICY "Admins can view all single wash bookings"
  ON single_wash_bookings FOR SELECT
  TO authenticated
  USING (is_admin(auth.uid()));

CREATE POLICY "Admins can update all single wash bookings"
  ON single_wash_bookings FOR UPDATE
  TO authenticated
  USING (is_admin(auth.uid()))
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "Admins can delete single wash bookings"
  ON single_wash_bookings FOR DELETE
  TO authenticated
  USING (is_admin(auth.uid()));