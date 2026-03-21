/*
  # Fix Ambiguous Email Column Reference in Admin Functions

  1. Changes
    - Update `get_all_user_details` function to explicitly qualify email columns
    - Ensure proper table qualification when joining user_profiles and auth.users
    - Fix any ambiguous column references

  2. Security
    - Maintains existing security model (admin-only access)
    - No changes to RLS policies
*/

-- Drop and recreate the get_all_user_details function with explicit qualifications
CREATE OR REPLACE FUNCTION get_all_user_details()
RETURNS TABLE (
  id uuid,
  user_id uuid,
  email text,
  role text,
  created_at timestamptz
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
STABLE
AS $$
BEGIN
  -- Check if the caller is an admin
  IF NOT is_admin(auth.uid()) THEN
    RAISE EXCEPTION 'Access denied. Admin privileges required.';
  END IF;

  -- Return user details with emails explicitly qualified
  RETURN QUERY
  SELECT 
    ur.id,
    ur.user_id,
    au.email as email,
    ur.role,
    ur.created_at
  FROM user_roles ur
  LEFT JOIN auth.users au ON au.id = ur.user_id
  ORDER BY ur.created_at DESC;
END;
$$;

-- Update policy on user_profiles to use explicit table qualification
DROP POLICY IF EXISTS "Admins can view all profiles" ON user_profiles;

CREATE POLICY "Admins can view all profiles"
  ON user_profiles
  FOR SELECT
  TO authenticated
  USING (is_admin(auth.uid()));
