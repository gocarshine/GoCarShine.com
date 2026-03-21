/*
  # Create admin roles and user roles tables

  1. New Tables
    - `user_roles`
      - `id` (uuid, primary key)
      - `user_id` (uuid) - Reference to authenticated user
      - `role` (text) - Role type: 'admin' or 'user'
      - `created_at` (timestamptz)
    - `admins`
      - `id` (uuid, primary key)
      - `user_id` (uuid) - Reference to authenticated user
      - `email` (text) - Admin email
      - `is_active` (boolean) - Admin status
      - `created_at` (timestamptz)

  2. Indexes
    - Index on user_id for fast lookups

  3. Security
    - Enable RLS on both tables
    - Only admins can view and manage admin/user data
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_name = 'user_roles'
  ) THEN
    CREATE TABLE user_roles (
      id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
      user_id uuid NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
      role text NOT NULL DEFAULT 'user' CHECK (role IN ('admin', 'user')),
      created_at timestamptz DEFAULT now()
    );

    CREATE INDEX idx_user_roles_user_id ON user_roles(user_id);
    ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;

    CREATE POLICY "Users can view own role"
      ON user_roles
      FOR SELECT
      TO authenticated
      USING (auth.uid() = user_id);

    CREATE POLICY "Admins can view all roles"
      ON user_roles
      FOR SELECT
      TO authenticated
      USING (
        EXISTS (
          SELECT 1 FROM user_roles ur
          WHERE ur.user_id = auth.uid() AND ur.role = 'admin'
        )
      );

    CREATE POLICY "Admins can update roles"
      ON user_roles
      FOR UPDATE
      TO authenticated
      USING (
        EXISTS (
          SELECT 1 FROM user_roles ur
          WHERE ur.user_id = auth.uid() AND ur.role = 'admin'
        )
      )
      WITH CHECK (
        EXISTS (
          SELECT 1 FROM user_roles ur
          WHERE ur.user_id = auth.uid() AND ur.role = 'admin'
        )
      );
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_name = 'admins'
  ) THEN
    CREATE TABLE admins (
      id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
      user_id uuid NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
      email text NOT NULL,
      is_active boolean DEFAULT true,
      created_at timestamptz DEFAULT now()
    );

    CREATE INDEX idx_admins_user_id ON admins(user_id);
    ALTER TABLE admins ENABLE ROW LEVEL SECURITY;

    CREATE POLICY "Admins can view all admins"
      ON admins
      FOR SELECT
      TO authenticated
      USING (
        EXISTS (
          SELECT 1 FROM user_roles ur
          WHERE ur.user_id = auth.uid() AND ur.role = 'admin'
        )
      );

    CREATE POLICY "Admins can update admins"
      ON admins
      FOR UPDATE
      TO authenticated
      USING (
        EXISTS (
          SELECT 1 FROM user_roles ur
          WHERE ur.user_id = auth.uid() AND ur.role = 'admin'
        )
      )
      WITH CHECK (
        EXISTS (
          SELECT 1 FROM user_roles ur
          WHERE ur.user_id = auth.uid() AND ur.role = 'admin'
        )
      );
  END IF;
END $$;
