/*
  # Create SMS OTP Table

  1. New Tables
    - `sms_otps`
      - `id` (uuid, primary key)
      - `contact_no` (text, required)
      - `otp` (text, required)
      - `created_at` (timestamptz)
      - `expires_at` (timestamptz)
      - `verified` (boolean)
  
  2. Security
    - Enable RLS on `sms_otps` table
    - Anonymous users can insert OTPs
    - No one can select OTPs directly (only through functions)
  
  3. Notes
    - OTPs expire after 10 minutes
    - This table is used for phone verification
*/

-- Create sms_otps table
CREATE TABLE IF NOT EXISTS sms_otps (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  contact_no text NOT NULL,
  otp text NOT NULL,
  created_at timestamptz DEFAULT now(),
  expires_at timestamptz DEFAULT (now() + interval '10 minutes'),
  verified boolean DEFAULT false
);

-- Create index on contact_no and expires_at for fast lookups
CREATE INDEX IF NOT EXISTS idx_sms_otps_contact_no ON sms_otps(contact_no);
CREATE INDEX IF NOT EXISTS idx_sms_otps_expires_at ON sms_otps(expires_at);

-- Enable RLS
ALTER TABLE sms_otps ENABLE ROW LEVEL SECURITY;

-- Allow anonymous users to insert OTPs
CREATE POLICY "Anyone can insert OTP"
  ON sms_otps
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

-- Function to verify SMS OTP
CREATE OR REPLACE FUNCTION verify_sms_otp(
  p_contact_no text,
  p_otp text
) RETURNS boolean AS $$
DECLARE
  v_valid boolean;
BEGIN
  -- Check if OTP exists, is not expired, and not already verified
  SELECT EXISTS (
    SELECT 1
    FROM sms_otps
    WHERE contact_no = p_contact_no
      AND otp = p_otp
      AND expires_at > now()
      AND verified = false
  ) INTO v_valid;

  -- If valid, mark as verified
  IF v_valid THEN
    UPDATE sms_otps
    SET verified = true
    WHERE contact_no = p_contact_no
      AND otp = p_otp
      AND expires_at > now()
      AND verified = false;
  END IF;

  RETURN v_valid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to generate and store SMS OTP
CREATE OR REPLACE FUNCTION generate_sms_otp(
  p_contact_no text
) RETURNS text AS $$
DECLARE
  v_otp text;
BEGIN
  -- Generate 6-digit OTP
  v_otp := LPAD(FLOOR(RANDOM() * 1000000)::text, 6, '0');

  -- Insert OTP
  INSERT INTO sms_otps (contact_no, otp)
  VALUES (p_contact_no, v_otp);

  RETURN v_otp;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Clean up expired OTPs (optional, can be run periodically)
CREATE OR REPLACE FUNCTION cleanup_expired_otps() RETURNS void AS $$
BEGIN
  DELETE FROM sms_otps
  WHERE expires_at < now() - interval '1 day';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
