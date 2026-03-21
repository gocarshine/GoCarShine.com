/*
  # Grant Read Access to auth.users Table

  1. Changes
    - Grant SELECT permission on auth.users to authenticated users
    - Grant SELECT permission on auth.users to service_role
    - This allows the application to read user data from auth.users table
  
  2. Security
    - Only SELECT (read) permission is granted
    - No write permissions are granted
    - Users can only read, not modify auth.users
*/

-- Grant SELECT permission on auth.users to authenticated users
GRANT SELECT ON auth.users TO authenticated;

-- Grant SELECT permission on auth.users to service_role
GRANT SELECT ON auth.users TO service_role;
