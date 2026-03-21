/*
  # Create function to get user details for admins

  1. New Function
    - `get_all_user_details()` - Returns user information with emails
      - Combines user_roles with auth.users email
      - Only callable by admins via security check

  2. Security
    - Function uses SECURITY DEFINER to bypass RLS on auth.users
    - Checks if caller is admin before returning data

  3. Notes
    - This allows admin users to view user emails without direct access to auth.users
    - Prevents permission denied errors when querying user information
*/

-- Create a function to get user email (bypasses RLS)
CREATE OR REPLACE FUNCTION get_user_email(user_id uuid)
RETURNS text
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
STABLE
AS $$
  SELECT email FROM auth.users WHERE id = $1;
$$;

-- Create a function to get all user details (admin only)
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

  -- Return user details with emails
  RETURN QUERY
  SELECT 
    ur.id,
    ur.user_id,
    (SELECT email FROM auth.users WHERE id = ur.user_id) as email,
    ur.role,
    ur.created_at
  FROM user_roles ur
  ORDER BY ur.created_at DESC;
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION get_all_user_details() TO authenticated;
GRANT EXECUTE ON FUNCTION get_user_email(uuid) TO authenticated;