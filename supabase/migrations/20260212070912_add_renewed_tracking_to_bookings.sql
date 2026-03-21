/*
  # Add renewed tracking to bookings

  1. Changes
    - Add `has_been_renewed` boolean column to track if a booking has been renewed
    - Add `renewed_at` timestamp column to track when the renewal happened
    - Default `has_been_renewed` to false for existing records
  
  2. Purpose
    - Prevent multiple renewals of the same booking
    - Track renewal history
*/

-- Add columns to track renewal status
ALTER TABLE bookings 
ADD COLUMN IF NOT EXISTS has_been_renewed boolean DEFAULT false,
ADD COLUMN IF NOT EXISTS renewed_at timestamptz;

-- Update existing records to ensure they have the default value
UPDATE bookings 
SET has_been_renewed = false 
WHERE has_been_renewed IS NULL;