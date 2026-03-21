/*
  # Add delete policy for user_roles

  1. Changes
    - Add DELETE policy for user_roles table
    - Only admins can delete user role records

  2. Security
    - Uses the is_admin helper function to check permissions
    - Prevents unauthorized deletion of user roles
*/

-- Add delete policy for user_roles
CREATE POLICY "Admins can delete user roles"
  ON user_roles
  FOR DELETE
  TO authenticated
  USING (is_admin(auth.uid()));