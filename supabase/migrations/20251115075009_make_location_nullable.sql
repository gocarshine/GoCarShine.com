/*
  # Make location column nullable

  1. Changes
    - Alter `location` column to allow NULL values
    - This column is not required for package bookings where address is used instead

  2. Notes
    - Address field is used for package bookings
    - Location field can remain for other booking types
*/

ALTER TABLE bookings ALTER COLUMN location DROP NOT NULL;