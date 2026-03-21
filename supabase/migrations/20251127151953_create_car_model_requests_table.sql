/*
  # Create car model requests table

  1. New Tables
    - `car_model_requests`
      - `id` (uuid, primary key) - Unique identifier
      - `user_id` (uuid, nullable) - Reference to auth.users if logged in
      - `name` (text, required) - Name of the person requesting
      - `phone_no` (text, required) - Contact phone number
      - `car_model` (text, required) - The car model they want added
      - `status` (text, default: 'pending') - Request status (pending, approved, rejected)
      - `created_at` (timestamptz) - When the request was created
      
  2. Security
    - Enable RLS on `car_model_requests` table
    - Add policy for authenticated users to insert their own requests
    - Add policy for authenticated users to view their own requests
    - Add policy for unauthenticated users to insert requests (for non-logged in users)
    - Add policy for admins to view all requests
    - Add policy for admins to update request status
*/

CREATE TABLE IF NOT EXISTS car_model_requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  name text NOT NULL,
  phone_no text NOT NULL,
  car_model text NOT NULL,
  status text DEFAULT 'pending',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE car_model_requests ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can insert own requests"
  ON car_model_requests
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id OR user_id IS NULL);

CREATE POLICY "Unauthenticated users can insert requests"
  ON car_model_requests
  FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "Users can view own requests"
  ON car_model_requests
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Admins can view all requests"
  ON car_model_requests
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM user_roles
      WHERE user_roles.user_id = auth.uid()
      AND user_roles.role = 'admin'
    )
  );

CREATE POLICY "Admins can update request status"
  ON car_model_requests
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM user_roles
      WHERE user_roles.user_id = auth.uid()
      AND user_roles.role = 'admin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM user_roles
      WHERE user_roles.user_id = auth.uid()
      AND user_roles.role = 'admin'
    )
  );