/*
  # Update Single Wash Booking Prices

  1. Changes
    - Drop the old price check constraint that only allowed 200 or 300
    - Update existing bookings with old prices (200 -> 250, 300 -> 350)
    - Add new price check constraint that allows 250 or 350
  
  2. Security
    - No changes to RLS policies
*/

ALTER TABLE single_wash_bookings 
DROP CONSTRAINT IF EXISTS single_wash_bookings_price_check;

UPDATE single_wash_bookings
SET price = 250
WHERE price = 200;

UPDATE single_wash_bookings
SET price = 350
WHERE price = 300;

ALTER TABLE single_wash_bookings 
ADD CONSTRAINT single_wash_bookings_price_check 
CHECK (price = ANY (ARRAY[250, 350]));
