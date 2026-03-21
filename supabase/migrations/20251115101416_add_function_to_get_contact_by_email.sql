/*
  # Add function to get contact number by email

  1. New Functions
    - `get_contact_no_by_email` - Returns contact number for a given email
  
  2. Security
    - Function is SECURITY DEFINER to allow access to user_profiles
    - Anonymous users can call this function for login purposes
*/

-- Function to get contact number by email
CREATE OR REPLACE FUNCTION get_contact_no_by_email(
  p_email text
) RETURNS text AS $$
DECLARE
  v_contact_no text;
BEGIN
  SELECT up.contact_no
  INTO v_contact_no
  FROM user_profiles up
  INNER JOIN auth.users u ON u.id = up.id
  WHERE u.email = p_email;

  RETURN v_contact_no;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
