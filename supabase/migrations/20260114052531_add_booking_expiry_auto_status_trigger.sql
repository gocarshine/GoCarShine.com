/*
  # Add Automatic Expiry Status Management for Bookings

  1. Changes
    - Update status column constraint to include 'expired' as a valid status
    - Create trigger function to automatically manage booking expiry status
    - Create trigger to prevent modifications to expired bookings
    - Backfill existing bookings with appropriate expired/cancelled statuses

  2. Expiry Logic (Case-Insensitive)
    - Set status = 'EXPIRED' when:
      - expiry_date < CURRENT_DATE
      - AND status IN ('confirmed', 'completed', 'in_progress')
    - Set status = 'CANCELLED' when:
      - expiry_date < CURRENT_DATE
      - AND status = 'pending'

  3. Protection Rules
    - No modifications allowed once status is 'EXPIRED'
    - Trigger applies to both INSERT and UPDATE operations
    - Applies to all existing records with past expiry dates

  4. Security
    - Maintains existing RLS policies
    - Adds safeguard to prevent expired booking modifications
*/

-- Step 1: Drop existing constraint and add new one with 'expired' status
DO $$
BEGIN
  -- Drop the old constraint if it exists
  ALTER TABLE bookings DROP CONSTRAINT IF EXISTS bookings_status_check;
  
  -- Add new constraint with 'expired' included
  ALTER TABLE bookings ADD CONSTRAINT bookings_status_check 
    CHECK (status IN ('pending', 'confirmed', 'in_progress', 'completed', 'cancelled', 'expired'));
END $$;

-- Step 2: Create function to automatically handle expiry status
CREATE OR REPLACE FUNCTION handle_booking_expiry_status()
RETURNS TRIGGER AS $$
BEGIN
  -- Prevent any modifications to expired bookings
  IF OLD.status IS NOT NULL AND LOWER(OLD.status) = 'expired' THEN
    RAISE EXCEPTION 'Cannot modify a booking with EXPIRED status';
  END IF;

  -- Auto-set expiry status based on expiry date (only if expiry_date exists)
  IF NEW.expiry_date IS NOT NULL AND NEW.expiry_date < CURRENT_DATE THEN
    -- Check if status should be EXPIRED (for confirmed, completed, in_progress)
    IF LOWER(NEW.status) IN ('confirmed', 'completed', 'in_progress') THEN
      NEW.status := 'expired';
    -- Check if status should be CANCELLED (for pending)
    ELSIF LOWER(NEW.status) = 'pending' THEN
      NEW.status := 'cancelled';
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Step 3: Create trigger to run before INSERT or UPDATE
DROP TRIGGER IF EXISTS booking_expiry_status_trigger ON bookings;
CREATE TRIGGER booking_expiry_status_trigger
  BEFORE INSERT OR UPDATE ON bookings
  FOR EACH ROW
  EXECUTE FUNCTION handle_booking_expiry_status();

-- Step 4: Apply expiry logic to all existing bookings with past expiry dates
UPDATE bookings
SET status = CASE
  WHEN LOWER(status) IN ('confirmed', 'completed', 'in_progress') THEN 'expired'
  WHEN LOWER(status) = 'pending' THEN 'cancelled'
  ELSE status
END
WHERE expiry_date IS NOT NULL 
  AND expiry_date < CURRENT_DATE
  AND LOWER(status) IN ('pending', 'confirmed', 'completed', 'in_progress');
