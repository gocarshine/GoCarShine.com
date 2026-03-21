/*
  # Backfill Missing User Profiles

  1. Changes
    - Insert user_profiles for all existing auth.users that don't have profiles
    - Use SECURITY DEFINER function to bypass RLS during backfill
  
  2. Data Safety
    - Uses ON CONFLICT to prevent duplicate entries
    - Only adds missing profiles, doesn't modify existing ones
*/

-- Create temporary function to backfill profiles
CREATE OR REPLACE FUNCTION backfill_user_profiles()
RETURNS void
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO public.user_profiles (id, contact_no, email)
  SELECT au.id, COALESCE(au.phone, ''), au.email
  FROM auth.users au
  LEFT JOIN public.user_profiles up ON au.id = up.id
  WHERE up.id IS NULL
  ON CONFLICT (id) DO NOTHING;
END;
$$;

-- Execute the backfill
SELECT backfill_user_profiles();

-- Drop the temporary function
DROP FUNCTION backfill_user_profiles();