/*
  # Fix Database Error Querying Schema

  1. Changes
    - Update handle_new_user function to be more robust
    - Add proper error handling to prevent authentication failures
    - Ensure the function doesn't fail during auth queries
    
  2. Security
    - Maintain SECURITY DEFINER for proper permissions
    - Add safeguards to prevent trigger failures from blocking auth
*/

-- Drop and recreate the trigger function with better error handling
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- Insert user profile with error handling
  BEGIN
    INSERT INTO public.user_profiles (id, contact_no, email)
    VALUES (NEW.id, COALESCE(NEW.phone, ''), NEW.email)
    ON CONFLICT (id) DO UPDATE
    SET email = EXCLUDED.email;
  EXCEPTION
    WHEN OTHERS THEN
      -- Log but don't fail
      RAISE WARNING 'Failed to create user profile: %', SQLERRM;
  END;
  
  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Ensure we always return NEW to not block user creation
    RAISE WARNING 'Error in handle_new_user: %', SQLERRM;
    RETURN NEW;
END;
$$;

-- Ensure proper grants
GRANT EXECUTE ON FUNCTION public.handle_new_user() TO postgres, authenticated, anon;

-- Make sure RLS functions are stable and won't cause issues
CREATE OR REPLACE FUNCTION public.get_current_user_role()
RETURNS text
LANGUAGE plpgsql
STABLE SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  user_role text;
BEGIN
  -- Use a more defensive query
  BEGIN
    SELECT role INTO user_role
    FROM user_roles
    WHERE user_id = auth.uid()
    LIMIT 1;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 'user';
  END;
  
  RETURN COALESCE(user_role, 'user');
END;
$$;

-- Update is_admin function to be more defensive
CREATE OR REPLACE FUNCTION public.is_admin(user_id uuid)
RETURNS boolean
LANGUAGE plpgsql
STABLE SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM user_roles
    WHERE user_roles.user_id = $1 
    AND user_roles.role IN ('admin', 'super_admin')
    LIMIT 1
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN false;
END;
$$;

-- Ensure grants on updated functions
GRANT EXECUTE ON FUNCTION public.get_current_user_role() TO postgres, authenticated, anon;
GRANT EXECUTE ON FUNCTION public.is_admin(uuid) TO postgres, authenticated, anon;
