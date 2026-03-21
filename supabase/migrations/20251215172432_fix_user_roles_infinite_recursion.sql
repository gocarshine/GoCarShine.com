/*
  # Fix Infinite Recursion in user_roles Policies

  ## Problem
  The RLS policies on user_roles table were querying the same table to check permissions,
  causing infinite recursion when policies evaluate.

  ## Solution
  1. Create a SECURITY DEFINER function that bypasses RLS to check user roles
  2. Update all policies to use this function instead of querying user_roles directly
  3. This breaks the circular dependency while maintaining security

  ## Changes
  - Create get_current_user_role() function with SECURITY DEFINER
  - Drop and recreate all user_roles policies to use the new function
  - Maintain same permission model: super_admin has full control, admins can view
*/

-- Step 1: Create a SECURITY DEFINER function to get current user's role without triggering RLS
CREATE OR REPLACE FUNCTION get_current_user_role()
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
STABLE
AS $$
DECLARE
  user_role text;
BEGIN
  SELECT role INTO user_role
  FROM user_roles
  WHERE user_id = auth.uid();
  
  RETURN COALESCE(user_role, 'user');
END;
$$;

-- Step 2: Drop all existing policies on user_roles
DROP POLICY IF EXISTS "Users can view own role" ON user_roles;
DROP POLICY IF EXISTS "Super admins and admins can view all roles" ON user_roles;
DROP POLICY IF EXISTS "Only super admins can update roles" ON user_roles;
DROP POLICY IF EXISTS "Only super admins can insert roles" ON user_roles;
DROP POLICY IF EXISTS "Only super admins can delete roles" ON user_roles;
DROP POLICY IF EXISTS "Admins can view all roles" ON user_roles;
DROP POLICY IF EXISTS "Admins can update roles" ON user_roles;

-- Step 3: Create new policies using the SECURITY DEFINER function

-- Policy: Users can view their own role
CREATE POLICY "Users can view own role"
  ON user_roles
  FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

-- Policy: Super admins and admins can view all roles
CREATE POLICY "Super admins and admins can view all roles"
  ON user_roles
  FOR SELECT
  TO authenticated
  USING (get_current_user_role() IN ('super_admin', 'admin'));

-- Policy: Only super admins can update roles
CREATE POLICY "Only super admins can update roles"
  ON user_roles
  FOR UPDATE
  TO authenticated
  USING (get_current_user_role() = 'super_admin')
  WITH CHECK (get_current_user_role() = 'super_admin');

-- Policy: Only super admins can insert new roles
CREATE POLICY "Only super admins can insert roles"
  ON user_roles
  FOR INSERT
  TO authenticated
  WITH CHECK (get_current_user_role() = 'super_admin');

-- Policy: Only super admins can delete roles (prevent self-deletion)
CREATE POLICY "Only super admins can delete roles"
  ON user_roles
  FOR DELETE
  TO authenticated
  USING (
    get_current_user_role() = 'super_admin'
    AND user_id != auth.uid()
  );

-- Step 4: Update admins table policies to use the same function

-- Drop existing admin table policies
DROP POLICY IF EXISTS "Admins can view all admins" ON admins;
DROP POLICY IF EXISTS "Only super admins can update admins" ON admins;
DROP POLICY IF EXISTS "Only super admins can insert admins" ON admins;
DROP POLICY IF EXISTS "Only super admins can delete admins" ON admins;
DROP POLICY IF EXISTS "Admins can update admins" ON admins;

-- Recreate with the helper function
CREATE POLICY "Super admins and admins can view all admins"
  ON admins
  FOR SELECT
  TO authenticated
  USING (get_current_user_role() IN ('super_admin', 'admin'));

CREATE POLICY "Only super admins can update admins"
  ON admins
  FOR UPDATE
  TO authenticated
  USING (get_current_user_role() = 'super_admin')
  WITH CHECK (get_current_user_role() = 'super_admin');

CREATE POLICY "Only super admins can insert admins"
  ON admins
  FOR INSERT
  TO authenticated
  WITH CHECK (get_current_user_role() = 'super_admin');

CREATE POLICY "Only super admins can delete admins"
  ON admins
  FOR DELETE
  TO authenticated
  USING (get_current_user_role() = 'super_admin');