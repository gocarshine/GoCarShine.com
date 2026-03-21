/*
  # Fix bookings table policies to avoid auth.users access

  1. Changes
    - Drop existing policies that directly access auth.users
    - Recreate policies using helper functions to safely access user data
    - Allows users to view and insert their own bookings without permission errors

  2. Security
    - Uses get_user_email helper function to bypass RLS on auth.users
    - Maintains secure access control for bookings
    - Users can only access their own bookings
    - Admins can access all bookings

  3. Notes
    - Fixes "permission denied for table users" error
    - Policies now use SECURITY DEFINER functions for safe data access
*/

-- Drop existing problematic policies
DROP POLICY IF EXISTS "Users can view own bookings" ON bookings;
DROP POLICY IF EXISTS "Users can insert own bookings" ON bookings;
DROP POLICY IF EXISTS "Admins can view all bookings" ON bookings;
DROP POLICY IF EXISTS "Admins can update all bookings" ON bookings;

-- Recreate policies using helper functions
CREATE POLICY "Users can view own bookings"
  ON bookings
  FOR SELECT
  TO authenticated
  USING (email = get_user_email(auth.uid()));

CREATE POLICY "Admins can view all bookings"
  ON bookings
  FOR SELECT
  TO authenticated
  USING (is_admin(auth.uid()));

CREATE POLICY "Users can insert own bookings"
  ON bookings
  FOR INSERT
  TO authenticated
  WITH CHECK (email = get_user_email(auth.uid()));

CREATE POLICY "Admins can update all bookings"
  ON bookings
  FOR UPDATE
  TO authenticated
  USING (is_admin(auth.uid()))
  WITH CHECK (is_admin(auth.uid()));