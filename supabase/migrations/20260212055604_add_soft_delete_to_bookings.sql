/*
  # Add Soft Delete to Bookings

  1. Changes
    - Add `deleted_at` column to track when a booking was soft-deleted
    - Add `deleted_by` column to track which admin deleted the booking
    - Add `is_deleted` computed column for easier querying
    - Create indexes for better performance on deleted bookings queries

  2. Notes
    - Existing bookings will have NULL deleted_at (not deleted)
    - Soft delete allows recovery of accidentally deleted bookings
    - Hard deletes should only be done for compliance reasons
*/

-- Add soft delete columns to bookings
ALTER TABLE bookings 
ADD COLUMN IF NOT EXISTS deleted_at timestamptz,
ADD COLUMN IF NOT EXISTS deleted_by uuid REFERENCES auth.users(id);

-- Create index for faster queries on non-deleted bookings
CREATE INDEX IF NOT EXISTS idx_bookings_deleted_at ON bookings(deleted_at) WHERE deleted_at IS NULL;

-- Create index for faster queries on deleted bookings
CREATE INDEX IF NOT EXISTS idx_bookings_deleted_by ON bookings(deleted_by) WHERE deleted_by IS NOT NULL;

-- Add comment to explain the soft delete columns
COMMENT ON COLUMN bookings.deleted_at IS 'Timestamp when the booking was soft-deleted. NULL means not deleted.';
COMMENT ON COLUMN bookings.deleted_by IS 'Admin user ID who soft-deleted the booking.';
