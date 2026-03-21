/*
  # Make contact_no nullable and populate user_profiles

  1. Changes
    - Make contact_no nullable in user_profiles
    - Populate user_profiles for existing auth.users who don't have profiles
  
  2. Security
    - Maintains existing RLS policies
  
  3. Notes
    - Existing users without contact numbers can still log in with email
    - New users must provide contact number during signup
*/

-- Make contact_no nullable
ALTER TABLE user_profiles 
ALTER COLUMN contact_no DROP NOT NULL;

-- Populate user_profiles for existing users
INSERT INTO user_profiles (id, email, contact_no)
SELECT 
  u.id,
  u.email,
  NULL as contact_no
FROM auth.users u
LEFT JOIN user_profiles up ON u.id = up.id
WHERE up.id IS NULL
ON CONFLICT (id) DO NOTHING;
