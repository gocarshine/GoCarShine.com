/*
  # Add Super Admin Role and Permissions

  ## Overview
  This migration adds a super_admin role type and configures role-based access control.
  
  ## Changes
  
  1. **Modify user_roles table**
     - Add 'super_admin' to allowed role types
     - Existing roles: 'admin', 'user'
     - New role: 'super_admin'
  
  2. **Set Super Admin**
     - Assign prathvi.edu@gmail.com as super_admin
  
  3. **Update RLS Policies**
     - Super admins can manage all roles and users
     - Admins have limited permissions (cannot delete users or manage roles)
     - Regular admins cannot modify super_admin roles
  
  4. **Security**
     - Only super_admin can create/update/delete admin users
     - Only super_admin can change user roles
     - Regular admins can view but not modify roles
*/

-- Step 1: Modify the CHECK constraint to allow 'super_admin' role
DO $$
BEGIN
  -- Drop the existing constraint if it exists
  IF EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE constraint_name = 'user_roles_role_check'
    AND table_name = 'user_roles'
  ) THEN
    ALTER TABLE user_roles DROP CONSTRAINT user_roles_role_check;
  END IF;

  -- Add new constraint with super_admin included
  ALTER TABLE user_roles ADD CONSTRAINT user_roles_role_check 
    CHECK (role IN ('super_admin', 'admin', 'user'));
END $$;

-- Step 2: Set prathvi.edu@gmail.com as super_admin
DO $$
DECLARE
  v_user_id uuid;
BEGIN
  -- Get the user_id for prathvi.edu@gmail.com from auth.users
  SELECT id INTO v_user_id
  FROM auth.users
  WHERE email = 'prathvi.edu@gmail.com'
  LIMIT 1;

  -- If user exists, update or insert their role as super_admin
  IF v_user_id IS NOT NULL THEN
    INSERT INTO user_roles (user_id, role)
    VALUES (v_user_id, 'super_admin')
    ON CONFLICT (user_id) 
    DO UPDATE SET role = 'super_admin';
  END IF;
END $$;

-- Step 3: Update RLS policies for role management

-- Drop existing policies that need to be updated
DROP POLICY IF EXISTS "Admins can update roles" ON user_roles;
DROP POLICY IF EXISTS "Admins can view all roles" ON user_roles;

-- Create new policies with super_admin distinction

-- Policy: All authenticated users can view their own role
-- (This policy already exists: "Users can view own role")

-- Policy: Super admins and admins can view all roles
CREATE POLICY "Super admins and admins can view all roles"
  ON user_roles
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM user_roles ur
      WHERE ur.user_id = auth.uid() 
      AND ur.role IN ('super_admin', 'admin')
    )
  );

-- Policy: Only super admins can update roles
CREATE POLICY "Only super admins can update roles"
  ON user_roles
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM user_roles ur
      WHERE ur.user_id = auth.uid() AND ur.role = 'super_admin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM user_roles ur
      WHERE ur.user_id = auth.uid() AND ur.role = 'super_admin'
    )
  );

-- Policy: Only super admins can insert new roles
CREATE POLICY "Only super admins can insert roles"
  ON user_roles
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM user_roles ur
      WHERE ur.user_id = auth.uid() AND ur.role = 'super_admin'
    )
  );

-- Policy: Only super admins can delete roles (but prevent self-deletion)
CREATE POLICY "Only super admins can delete roles"
  ON user_roles
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM user_roles ur
      WHERE ur.user_id = auth.uid() AND ur.role = 'super_admin'
    )
    AND user_id != auth.uid() -- Prevent super admin from deleting their own role
  );

-- Step 4: Update admins table policies

-- Drop existing admin table policies
DROP POLICY IF EXISTS "Admins can update admins" ON admins;

-- Policy: Only super admins can update admin records
CREATE POLICY "Only super admins can update admins"
  ON admins
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM user_roles ur
      WHERE ur.user_id = auth.uid() AND ur.role = 'super_admin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM user_roles ur
      WHERE ur.user_id = auth.uid() AND ur.role = 'super_admin'
    )
  );

-- Policy: Only super admins can insert admin records
CREATE POLICY "Only super admins can insert admins"
  ON admins
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM user_roles ur
      WHERE ur.user_id = auth.uid() AND ur.role = 'super_admin'
    )
  );

-- Policy: Only super admins can delete admin records
CREATE POLICY "Only super admins can delete admins"
  ON admins
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM user_roles ur
      WHERE ur.user_id = auth.uid() AND ur.role = 'super_admin'
    )
  );

-- Step 5: Create a helper function to check if user is super admin
CREATE OR REPLACE FUNCTION is_super_admin(user_id_param uuid)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM user_roles
    WHERE user_id = user_id_param AND role = 'super_admin'
  );
END;
$$;

-- Step 6: Create a helper function to get current user's role
CREATE OR REPLACE FUNCTION get_user_role(user_id_param uuid)
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  user_role text;
BEGIN
  SELECT role INTO user_role
  FROM user_roles
  WHERE user_id = user_id_param;
  
  RETURN COALESCE(user_role, 'user');
END;
$$;