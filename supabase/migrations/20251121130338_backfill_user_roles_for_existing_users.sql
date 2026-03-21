/*
  # Backfill user_roles for existing users

  1. Changes
    - Insert missing entries into user_roles for all auth.users
    - Set default role as 'user' for all new entries
    - Skip users who already have roles

  2. Security
    - No RLS changes
    - Only adds missing user role entries
*/

-- Insert user_roles entries for all auth.users who don't have one
INSERT INTO user_roles (user_id, role)
SELECT 
  au.id,
  'user' as role
FROM auth.users au
LEFT JOIN user_roles ur ON ur.user_id = au.id
WHERE ur.user_id IS NULL
ON CONFLICT (user_id) DO NOTHING;
