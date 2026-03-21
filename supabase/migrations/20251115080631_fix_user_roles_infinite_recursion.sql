/*
  # Fix infinite recursion in user_roles policies

  1. Changes
    - Drop existing policies on user_roles table that cause recursion
    - Create a helper function to check if user is admin (bypasses RLS)
    - Recreate policies using the helper function to avoid recursion

  2. Notes
    - The helper function uses SECURITY DEFINER to bypass RLS
    - This prevents the infinite loop when checking admin status
*/

-- Drop existing problematic policies
DROP POLICY IF EXISTS "Admins can view all roles" ON user_roles;
DROP POLICY IF EXISTS "Admins can update roles" ON user_roles;

-- Create a helper function to check if a user is an admin (bypasses RLS)
CREATE OR REPLACE FUNCTION is_admin(user_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 FROM user_roles
    WHERE user_roles.user_id = $1 AND user_roles.role = 'admin'
  );
$$;

-- Recreate admin policies using the helper function
CREATE POLICY "Admins can view all roles"
  ON user_roles
  FOR SELECT
  TO authenticated
  USING (is_admin(auth.uid()));

CREATE POLICY "Admins can update roles"
  ON user_roles
  FOR UPDATE
  TO authenticated
  USING (is_admin(auth.uid()))
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "Admins can insert roles"
  ON user_roles
  FOR INSERT
  TO authenticated
  WITH CHECK (is_admin(auth.uid()));

-- Update admins table policies to use the helper function
DROP POLICY IF EXISTS "Admins can view all admins" ON admins;
DROP POLICY IF EXISTS "Admins can update admins" ON admins;

CREATE POLICY "Admins can view all admins"
  ON admins
  FOR SELECT
  TO authenticated
  USING (is_admin(auth.uid()));

CREATE POLICY "Admins can update admins"
  ON admins
  FOR UPDATE
  TO authenticated
  USING (is_admin(auth.uid()))
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "Admins can insert admins"
  ON admins
  FOR INSERT
  TO authenticated
  WITH CHECK (is_admin(auth.uid()));