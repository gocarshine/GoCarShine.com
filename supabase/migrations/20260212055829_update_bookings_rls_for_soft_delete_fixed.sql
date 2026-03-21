/*
  # Update Bookings RLS Policies for Soft Delete (Fixed)

  1. Changes
    - Update SELECT policies to handle soft-deleted bookings properly
    - Users can only see their own non-deleted bookings
    - Admins can see all bookings including soft-deleted ones

  2. Security
    - Regular users see only non-deleted bookings
    - Admins can view and manage deleted bookings
*/

DROP POLICY IF EXISTS "Users can view own non-deleted bookings" ON bookings;
DROP POLICY IF EXISTS "Admins can view all bookings including deleted" ON bookings;

CREATE POLICY "Users can view own non-deleted bookings"
  ON bookings
  FOR SELECT
  TO authenticated
  USING (
    deleted_at IS NULL AND
    (
      email = (SELECT email FROM user_profiles WHERE id = auth.uid())
      OR
      auth.uid() IN (
        SELECT user_id FROM user_roles WHERE role IN ('admin', 'super_admin')
      )
    )
  );

CREATE POLICY "Admins can view all bookings including deleted"
  ON bookings
  FOR SELECT
  TO authenticated
  USING (
    auth.uid() IN (
      SELECT user_id FROM user_roles WHERE role IN ('admin', 'super_admin')
    )
  );

COMMENT ON POLICY "Users can view own non-deleted bookings" ON bookings IS 
'Users can only see their own non-deleted bookings. Admins bypass this.';

COMMENT ON POLICY "Admins can view all bookings including deleted" ON bookings IS 
'Admins can see all bookings including soft-deleted ones for recovery purposes.';
