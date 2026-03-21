/*
  # Clean Up Duplicate RLS Policies on user_roles Table

  ## Problem
  There are duplicate and conflicting policies on the user_roles table:
  - Old policies using is_admin() function
  - New policies using get_current_user_role() function
  
  This causes conflicts and prevents super admins from accessing the admin panel.

  ## Solution
  1. Drop ALL existing policies on user_roles table
  2. Update get_current_user_role() function to include SET search_path
  3. Recreate clean policies that work correctly for super admins

  ## Changes
  - Remove all duplicate policies
  - Fix get_current_user_role() function with proper search_path
  - Create final clean set of RLS policies
*/

-- Step 1: Update get_current_user_role function with proper search_path
CREATE OR REPLACE FUNCTION get_current_user_role()
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
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

-- Step 2: Drop ALL existing policies on user_roles (including old ones)
DROP POLICY IF EXISTS "Users can view own role" ON user_roles;
DROP POLICY IF EXISTS "Super admins and admins can view all roles" ON user_roles;
DROP POLICY IF EXISTS "Only super admins can update roles" ON user_roles;
DROP POLICY IF EXISTS "Only super admins can insert roles" ON user_roles;
DROP POLICY IF EXISTS "Only super admins can delete roles" ON user_roles;
DROP POLICY IF EXISTS "Admins can view all roles" ON user_roles;
DROP POLICY IF EXISTS "Admins can update roles" ON user_roles;
DROP POLICY IF EXISTS "Admins can insert roles" ON user_roles;
DROP POLICY IF EXISTS "Admins can delete user roles" ON user_roles;
DROP POLICY IF EXISTS "Users can insert own role" ON user_roles;

-- Step 3: Create clean policies

-- SELECT: Users can view their own role OR super admins/admins can view all
CREATE POLICY "Users can view own role"
  ON user_roles
  FOR SELECT
  TO authenticated
  USING (
    user_id = auth.uid() 
    OR get_current_user_role() IN ('super_admin', 'admin')
  );

-- UPDATE: Only super admins can update roles
CREATE POLICY "Only super admins can update roles"
  ON user_roles
  FOR UPDATE
  TO authenticated
  USING (get_current_user_role() = 'super_admin')
  WITH CHECK (get_current_user_role() = 'super_admin');

-- INSERT: Super admins can insert any role, regular users can only insert their own 'user' role
CREATE POLICY "Only super admins and users can insert roles"
  ON user_roles
  FOR INSERT
  TO authenticated
  WITH CHECK (
    get_current_user_role() = 'super_admin'
    OR (auth.uid() = user_id AND role = 'user')
  );

-- DELETE: Only super admins can delete roles (prevent self-deletion)
CREATE POLICY "Only super admins can delete roles"
  ON user_roles
  FOR DELETE
  TO authenticated
  USING (
    get_current_user_role() = 'super_admin'
    AND user_id != auth.uid()
  );