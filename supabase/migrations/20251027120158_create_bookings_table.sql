/*
  # Create bookings table

  1. New Tables
    - `bookings`
      - `id` (uuid, primary key) - Unique identifier for each booking
      - `location` (text) - Customer's location for the car wash service
      - `booking_date` (date) - Date when the service is requested
      - `booking_time` (time) - Time when the service is requested
      - `created_at` (timestamptz) - Timestamp when the booking was created
      - `status` (text) - Booking status (pending, confirmed, completed, cancelled)
  
  2. Security
    - Enable RLS on `bookings` table
    - Add policy for anyone to insert bookings (public form submission)
    - Add policy for authenticated users to view all bookings
*/

CREATE TABLE IF NOT EXISTS bookings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  location text NOT NULL,
  booking_date date NOT NULL,
  booking_time time NOT NULL,
  created_at timestamptz DEFAULT now(),
  status text DEFAULT 'pending'
);

ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can submit bookings"
  ON bookings
  FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "Authenticated users can view bookings"
  ON bookings
  FOR SELECT
  TO authenticated
  USING (true);