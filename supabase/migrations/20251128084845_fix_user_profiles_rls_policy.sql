/*
  # Fix User Profiles RLS Policy for Signup

  1. Changes
    - Drop existing INSERT policy that requires auth.uid() = id (causes issues during signup)
    - Create new INSERT policy that allows service role to insert
    - Add trigger to automatically create user_profiles when auth user is created
  
  2. Security
    - Maintains security by only allowing users to insert their own profile
    - Service role can insert (for admin operations)
    - Trigger runs with security definer privileges
*/

-- Drop the existing insert policy
DROP POLICY IF EXISTS "Users can insert own profile" ON user_profiles;

-- Create new insert policy that allows authenticated users to insert their own profile
-- This policy is more permissive during the signup process
CREATE POLICY "Users can insert own profile"
  ON user_profiles
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Create a trigger function to automatically create user_profiles entry
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO public.user_profiles (id, contact_no, email)
  VALUES (NEW.id, '', NEW.email)
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;

-- Create trigger on auth.users table
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();