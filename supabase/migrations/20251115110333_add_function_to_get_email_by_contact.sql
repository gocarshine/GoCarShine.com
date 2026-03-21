/*
  # Add function to get email by contact number

  1. New Functions
    - `get_email_by_contact_no` - Returns email for a given contact number
  
  2. Security
    - Function is SECURITY DEFINER to allow access to user_profiles
    - Anonymous users can call this function for login purposes
*/

-- Function to get email by contact number
CREATE OR REPLACE FUNCTION get_email_by_contact_no(
  p_contact_no text
) RETURNS text AS $$
DECLARE
  v_email text;
BEGIN
  SELECT email
  INTO v_email
  FROM user_profiles
  WHERE contact_no = p_contact_no;

  RETURN v_email;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
