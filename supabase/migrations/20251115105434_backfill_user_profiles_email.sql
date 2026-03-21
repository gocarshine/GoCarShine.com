/*
  # Backfill user_profiles email column

  1. Changes
    - Populate email column in user_profiles from auth.users
    - This is a one-time backfill for existing users
  
  2. Notes
    - Uses a DO block to safely access auth.users
    - Only updates rows where email is null
*/

-- Backfill emails for existing user profiles
DO $$
DECLARE
  user_record RECORD;
BEGIN
  -- Loop through user_profiles that don't have email set
  FOR user_record IN 
    SELECT up.id
    FROM user_profiles up
    WHERE up.email IS NULL
  LOOP
    -- Update with email from auth.users
    UPDATE user_profiles up
    SET email = (
      SELECT u.email 
      FROM auth.users u 
      WHERE u.id = up.id
    )
    WHERE up.id = user_record.id;
  END LOOP;
END $$;
