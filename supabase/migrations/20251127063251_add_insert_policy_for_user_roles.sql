/*
  # Add INSERT policy for user_roles table

  1. Changes
    - Add policy to allow authenticated users to insert their own role
    - This allows new users to automatically get a 'user' role on signup

  2. Security
    - Users can only insert their own user_id
    - Default role is enforced as 'user' at table level
*/

-- Drop existing insert policy if any
DO $$
BEGIN
  DROP POLICY IF EXISTS "Users can insert own role" ON user_roles;
EXCEPTION
  WHEN undefined_object THEN NULL;
END $$;

-- Allow authenticated users to insert their own role entry
CREATE POLICY "Users can insert own role"
  ON user_roles
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id AND role = 'user');
