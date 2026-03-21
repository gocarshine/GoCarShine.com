/*
  # Create user activity logs table

  1. New Tables
    - `user_logs`
      - `id` (uuid, primary key) - Unique identifier for each log entry
      - `user_id` (uuid) - Reference to authenticated user
      - `action` (text) - Action performed (login, logout, booking, etc.)
      - `details` (jsonb) - Additional context about the action
      - `ip_address` (text) - IP address from which action was performed
      - `timestamp` (timestamptz) - When the action occurred
      - `created_at` (timestamptz) - When log was created

  2. Indexes
    - Index on user_id for fast queries
    - Index on timestamp for sorting

  3. Security
    - Enable RLS on `user_logs` table
    - Allow users to view their own logs
    - Prevent direct insertion from clients
*/

CREATE TABLE IF NOT EXISTS user_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  action text NOT NULL,
  details jsonb DEFAULT NULL,
  ip_address text DEFAULT 'unknown',
  timestamp timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_user_logs_user_id ON user_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_user_logs_timestamp ON user_logs(timestamp DESC);

ALTER TABLE user_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own logs"
  ON user_logs
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);
