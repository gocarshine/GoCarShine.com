/*
  # Create Single Wash Bookings Table

  1. New Tables
    - `single_wash_bookings`
      - `id` (uuid, primary key)
      - `user_id` (uuid, foreign key to auth.users)
      - `name` (text)
      - `mobile` (text)
      - `car_model` (text)
      - `car_number` (text)
      - `wash_type` (text) - 'external' or 'internal_external'
      - `price` (integer) - 200 or 300
      - `booking_date` (date)
      - `preferred_time_slot` (text)
      - `location` (text)
      - `status` (text) - 'pending', 'confirmed', 'completed', 'cancelled'
      - `created_at` (timestamptz)
      - `updated_at` (timestamptz)
      
  2. Security
    - Enable RLS on `single_wash_bookings` table
    - Add policies for authenticated users to manage their own bookings
    - Add policies for admins to view and manage all bookings
*/

CREATE TABLE IF NOT EXISTS single_wash_bookings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
  name text NOT NULL,
  mobile text NOT NULL,
  car_model text NOT NULL,
  car_number text NOT NULL,
  wash_type text NOT NULL CHECK (wash_type IN ('external', 'internal_external')),
  price integer NOT NULL CHECK (price IN (200, 300)),
  booking_date date NOT NULL,
  preferred_time_slot text NOT NULL,
  location text NOT NULL,
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'completed', 'cancelled')),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE single_wash_bookings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own single wash bookings"
  ON single_wash_bookings FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own single wash bookings"
  ON single_wash_bookings FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own single wash bookings"
  ON single_wash_bookings FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Admins can view all single wash bookings"
  ON single_wash_bookings FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM user_roles
      WHERE user_roles.user_id = auth.uid()
      AND user_roles.role = 'admin'
    )
  );

CREATE POLICY "Admins can update all single wash bookings"
  ON single_wash_bookings FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM user_roles
      WHERE user_roles.user_id = auth.uid()
      AND user_roles.role = 'admin'
    )
  );

CREATE POLICY "Admins can delete single wash bookings"
  ON single_wash_bookings FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM user_roles
      WHERE user_roles.user_id = auth.uid()
      AND user_roles.role = 'admin'
    )
  );