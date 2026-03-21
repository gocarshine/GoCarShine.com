/*
  # Fix User Profiles Trigger with Proper Security

  1. Changes
    - Recreate trigger function with proper security context
    - Function bypasses RLS since it runs as security definer
    - Ensures user_profiles is created even during auth flow
  
  2. Security
    - Function runs with elevated privileges to bypass RLS
    - Only called by system trigger, not user accessible
*/

-- Drop existing trigger and function
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP FUNCTION IF EXISTS public.handle_new_user();

-- Create the trigger function with security definer
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
  -- Insert directly, bypassing RLS due to SECURITY DEFINER
  INSERT INTO public.user_profiles (id, contact_no, email)
  VALUES (NEW.id, COALESCE(NEW.phone, ''), NEW.email)
  ON CONFLICT (id) DO UPDATE
  SET email = EXCLUDED.email;
  
  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Log error but don't fail the user creation
    RAISE WARNING 'Failed to create user profile: %', SQLERRM;
    RETURN NEW;
END;
$$;

-- Recreate trigger on auth.users
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();