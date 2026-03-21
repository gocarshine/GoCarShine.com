/*
  # Update is_admin() Function to Include Super Admin Role

  ## Problem
  The is_admin() function only checks for 'admin' role, not 'super_admin'.
  This function is used throughout the database for RLS policies and function
  access control, preventing super admins from accessing admin-only features.

  ## Solution
  Update the is_admin() function to return true for both 'admin' and 'super_admin' roles.
  This will automatically fix all RLS policies and functions that use is_admin().

  ## Impact
  This change will allow super admins to:
  - View, update, and delete enquiries
  - Access user details functions
  - Manage user roles
  - Access user logs
  - Full access to all admin features
*/

-- Update is_admin function to check for both admin and super_admin roles
CREATE OR REPLACE FUNCTION is_admin(user_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 FROM user_roles
    WHERE user_roles.user_id = $1 
    AND user_roles.role IN ('admin', 'super_admin')
  );
$$;