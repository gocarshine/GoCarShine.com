/*
  # Add Package Expiry Date to Bookings Table

  1. Changes
    - Add `expiry_date` column to bookings table to track package expiration
    - Create function to automatically calculate expiry date based on package type
    - Create trigger to set expiry date on insert and update
    - Backfill existing bookings with calculated expiry dates

  2. Expiry Rules
    - Monthly Sparkle Package → 1 month from booking date
    - Quarterly Shine Package → 3 months from booking date
    - Yearly Prestige Package → 1 year from booking date

  3. Notes
    - Expiry date is calculated from created_at timestamp
    - Function only updates expiry_date if package_name is present
    - Existing bookings will be backfilled with calculated expiry dates
*/

-- Add expiry_date column
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS expiry_date date;

-- Create function to calculate expiry date based on package name
CREATE OR REPLACE FUNCTION calculate_package_expiry()
RETURNS TRIGGER AS $$
BEGIN
  -- Only calculate expiry if package_name exists
  IF NEW.package_name IS NOT NULL THEN
    CASE 
      WHEN LOWER(NEW.package_name) LIKE '%monthly%' OR LOWER(NEW.package_name) LIKE '%sparkle%' THEN
        NEW.expiry_date := (NEW.created_at + INTERVAL '1 month')::date;
      WHEN LOWER(NEW.package_name) LIKE '%quarterly%' OR LOWER(NEW.package_name) LIKE '%shine%' THEN
        NEW.expiry_date := (NEW.created_at + INTERVAL '3 months')::date;
      WHEN LOWER(NEW.package_name) LIKE '%yearly%' OR LOWER(NEW.package_name) LIKE '%prestige%' THEN
        NEW.expiry_date := (NEW.created_at + INTERVAL '1 year')::date;
      ELSE
        -- Default to NULL if package type is not recognized
        NEW.expiry_date := NULL;
    END CASE;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically set expiry date
DROP TRIGGER IF EXISTS set_package_expiry_trigger ON bookings;
CREATE TRIGGER set_package_expiry_trigger
  BEFORE INSERT OR UPDATE ON bookings
  FOR EACH ROW
  EXECUTE FUNCTION calculate_package_expiry();

-- Backfill existing bookings with expiry dates
UPDATE bookings
SET expiry_date = CASE 
  WHEN LOWER(package_name) LIKE '%monthly%' OR LOWER(package_name) LIKE '%sparkle%' THEN
    (created_at + INTERVAL '1 month')::date
  WHEN LOWER(package_name) LIKE '%quarterly%' OR LOWER(package_name) LIKE '%shine%' THEN
    (created_at + INTERVAL '3 months')::date
  WHEN LOWER(package_name) LIKE '%yearly%' OR LOWER(package_name) LIKE '%prestige%' THEN
    (created_at + INTERVAL '1 year')::date
  ELSE
    NULL
END
WHERE package_name IS NOT NULL AND expiry_date IS NULL;