/*
  # Fix get_contact_no_by_email function

  1. Changes
    - Update function to avoid direct access to auth.users
    - Use a different approach to match email with contact number
  
  2. Security
    - Function remains SECURITY DEFINER but with proper permissions
*/

-- Drop the old function
DROP FUNCTION IF EXISTS get_contact_no_by_email(text);

-- Create a new approach: store email in user_profiles during signup
-- First, add email column to user_profiles if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_profiles' AND column_name = 'email'
  ) THEN
    ALTER TABLE user_profiles ADD COLUMN email text;
    CREATE INDEX IF NOT EXISTS idx_user_profiles_email ON user_profiles(email);
  END IF;
END $$;

-- Create new function that uses email from user_profiles
CREATE OR REPLACE FUNCTION get_contact_no_by_email(
  p_email text
) RETURNS text AS $$
DECLARE
  v_contact_no text;
BEGIN
  SELECT contact_no
  INTO v_contact_no
  FROM user_profiles
  WHERE email = p_email;

  RETURN v_contact_no;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
