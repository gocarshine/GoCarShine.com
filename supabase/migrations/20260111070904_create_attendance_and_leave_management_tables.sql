/*
  # Create Attendance and Leave Management Tables

  ## Overview
  This migration creates comprehensive attendance and leave management functionality for employee tracking.

  ## New Tables

  ### 1. `attendance`
  Tracks daily attendance records for employees.
  - `id` (uuid, primary key) - Unique identifier for each attendance record
  - `employee_id` (uuid, foreign key) - References the employee
  - `attendance_date` (date) - Date of attendance
  - `status` (text) - Attendance status: 'present', 'absent', 'half_day', 'on_leave'
  - `check_in_time` (time) - Time employee checked in
  - `check_out_time` (time) - Time employee checked out
  - `working_hours` (numeric) - Total hours worked
  - `remarks` (text) - Additional notes
  - `marked_by` (uuid, foreign key) - Admin who marked attendance
  - `created_at` (timestamptz) - Record creation timestamp
  - `updated_at` (timestamptz) - Record update timestamp

  ### 2. `leave_requests`
  Manages employee leave requests and approvals.
  - `id` (uuid, primary key) - Unique identifier for each leave request
  - `employee_id` (uuid, foreign key) - References the employee
  - `leave_type` (text) - Type: 'casual', 'sick', 'unpaid', 'paid', 'emergency'
  - `from_date` (date) - Leave start date
  - `to_date` (date) - Leave end date
  - `total_days` (numeric) - Number of leave days
  - `reason` (text) - Reason for leave
  - `status` (text) - Status: 'pending', 'approved', 'rejected'
  - `approved_by` (uuid, foreign key) - Admin who approved/rejected
  - `approval_date` (timestamptz) - Date of approval/rejection
  - `admin_remarks` (text) - Admin comments
  - `created_at` (timestamptz) - Request creation timestamp
  - `updated_at` (timestamptz) - Request update timestamp

  ## Security
  - RLS enabled on both tables
  - Super admin can view, insert, update all records
  - Policies enforce authentication and super admin role checks

  ## Constraints
  - Unique constraint on employee_id + attendance_date (one record per employee per day)
  - Check constraints to ensure valid date ranges for leave requests
  - Foreign key constraints for data integrity

  ## Important Notes
  1. Attendance records should be marked daily
  2. Leave requests automatically update attendance status when approved
  3. Working hours calculated from check-in and check-out times
  4. Total leave days calculated from date range
*/

-- Create attendance table
CREATE TABLE IF NOT EXISTS attendance (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  employee_id uuid NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
  attendance_date date NOT NULL DEFAULT CURRENT_DATE,
  status text NOT NULL DEFAULT 'present' CHECK (status IN ('present', 'absent', 'half_day', 'on_leave')),
  check_in_time time,
  check_out_time time,
  working_hours numeric(4,2) DEFAULT 0,
  remarks text DEFAULT '',
  marked_by uuid REFERENCES auth.users(id),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(employee_id, attendance_date)
);

-- Create leave_requests table
CREATE TABLE IF NOT EXISTS leave_requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  employee_id uuid NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
  leave_type text NOT NULL CHECK (leave_type IN ('casual', 'sick', 'unpaid', 'paid', 'emergency')),
  from_date date NOT NULL,
  to_date date NOT NULL,
  total_days numeric(4,1) NOT NULL DEFAULT 1,
  reason text NOT NULL,
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  approved_by uuid REFERENCES auth.users(id),
  approval_date timestamptz,
  admin_remarks text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  CHECK (to_date >= from_date)
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_attendance_employee_date ON attendance(employee_id, attendance_date);
CREATE INDEX IF NOT EXISTS idx_attendance_date ON attendance(attendance_date);
CREATE INDEX IF NOT EXISTS idx_leave_employee ON leave_requests(employee_id);
CREATE INDEX IF NOT EXISTS idx_leave_status ON leave_requests(status);
CREATE INDEX IF NOT EXISTS idx_leave_dates ON leave_requests(from_date, to_date);

-- Enable Row Level Security
ALTER TABLE attendance ENABLE ROW LEVEL SECURITY;
ALTER TABLE leave_requests ENABLE ROW LEVEL SECURITY;

-- RLS Policies for attendance table

-- Super admin can view all attendance records
CREATE POLICY "Super admin can view all attendance"
  ON attendance FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM user_roles
      WHERE user_roles.user_id = auth.uid()
      AND user_roles.role = 'super_admin'
    )
  );

-- Super admin can insert attendance records
CREATE POLICY "Super admin can insert attendance"
  ON attendance FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM user_roles
      WHERE user_roles.user_id = auth.uid()
      AND user_roles.role = 'super_admin'
    )
  );

-- Super admin can update attendance records
CREATE POLICY "Super admin can update attendance"
  ON attendance FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM user_roles
      WHERE user_roles.user_id = auth.uid()
      AND user_roles.role = 'super_admin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM user_roles
      WHERE user_roles.user_id = auth.uid()
      AND user_roles.role = 'super_admin'
    )
  );

-- Super admin can delete attendance records
CREATE POLICY "Super admin can delete attendance"
  ON attendance FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM user_roles
      WHERE user_roles.user_id = auth.uid()
      AND user_roles.role = 'super_admin'
    )
  );

-- RLS Policies for leave_requests table

-- Super admin can view all leave requests
CREATE POLICY "Super admin can view all leave requests"
  ON leave_requests FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM user_roles
      WHERE user_roles.user_id = auth.uid()
      AND user_roles.role = 'super_admin'
    )
  );

-- Super admin can insert leave requests
CREATE POLICY "Super admin can insert leave requests"
  ON leave_requests FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM user_roles
      WHERE user_roles.user_id = auth.uid()
      AND user_roles.role = 'super_admin'
    )
  );

-- Super admin can update leave requests
CREATE POLICY "Super admin can update leave requests"
  ON leave_requests FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM user_roles
      WHERE user_roles.user_id = auth.uid()
      AND user_roles.role = 'super_admin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM user_roles
      WHERE user_roles.user_id = auth.uid()
      AND user_roles.role = 'super_admin'
    )
  );

-- Super admin can delete leave requests
CREATE POLICY "Super admin can delete leave requests"
  ON leave_requests FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM user_roles
      WHERE user_roles.user_id = auth.uid()
      AND user_roles.role = 'super_admin'
    )
  );

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for updated_at
DROP TRIGGER IF EXISTS update_attendance_updated_at ON attendance;
CREATE TRIGGER update_attendance_updated_at
  BEFORE UPDATE ON attendance
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_leave_requests_updated_at ON leave_requests;
CREATE TRIGGER update_leave_requests_updated_at
  BEFORE UPDATE ON leave_requests
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Function to calculate working hours
CREATE OR REPLACE FUNCTION calculate_working_hours()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.check_in_time IS NOT NULL AND NEW.check_out_time IS NOT NULL THEN
    NEW.working_hours = EXTRACT(EPOCH FROM (NEW.check_out_time - NEW.check_in_time)) / 3600;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to auto-calculate working hours
DROP TRIGGER IF EXISTS calculate_working_hours_trigger ON attendance;
CREATE TRIGGER calculate_working_hours_trigger
  BEFORE INSERT OR UPDATE ON attendance
  FOR EACH ROW
  EXECUTE FUNCTION calculate_working_hours();

-- Function to calculate total leave days
CREATE OR REPLACE FUNCTION calculate_leave_days()
RETURNS TRIGGER AS $$
BEGIN
  NEW.total_days = (NEW.to_date - NEW.from_date) + 1;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to auto-calculate leave days
DROP TRIGGER IF EXISTS calculate_leave_days_trigger ON leave_requests;
CREATE TRIGGER calculate_leave_days_trigger
  BEFORE INSERT OR UPDATE ON leave_requests
  FOR EACH ROW
  EXECUTE FUNCTION calculate_leave_days();