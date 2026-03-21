/*
  # Fix Function Result Type Mismatch

  1. Changes
    - Update `get_all_user_details` function to ensure column types match exactly
    - Cast columns explicitly to match the RETURNS TABLE definition

  2. Security
    - Maintains existing security model (admin-only access)
    - No changes to access control
*/

-- Drop and recreate the get_all_user_details function with proper type casting
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

  -- Return user details with emails explicitly qualified and properly cast
  RETURN QUERY
  SELECT 
    ur.id::uuid,
    ur.user_id::uuid,
    COALESCE(au.email, '')::text as email,
    ur.role::text,
    ur.created_at::timestamptz
  FROM user_roles ur
  LEFT JOIN auth.users au ON au.id = ur.user_id
  ORDER BY ur.created_at DESC;
END;
$$;
