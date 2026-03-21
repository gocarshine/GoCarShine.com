/*
  # Add Additional Fields to Employees Table

  ## Changes
  1. New Columns Added
    - `employee_number` (text, unique) - Auto-generated unique ID in format CE-EMP-0001
    - `aadhaar_number` (text, nullable) - Employee's Aadhaar card number
    - `location` (text, nullable) - Employee's location/area
    - `date_of_birth` (date, nullable) - Employee's date of birth

  2. Functions
    - `generate_employee_number()` - Function to generate next sequential employee number

  3. Triggers
    - Auto-populate employee_number before insert if not provided

  ## Notes
  - Employee numbers start from CE-EMP-0001 and increment sequentially
  - All new fields except employee_number are nullable for flexibility
  - Existing employees will need employee numbers backfilled
*/

-- Add new columns to employees table
DO $$
BEGIN
  -- Add employee_number column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'employees' AND column_name = 'employee_number'
  ) THEN
    ALTER TABLE employees ADD COLUMN employee_number text UNIQUE;
  END IF;

  -- Add aadhaar_number column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'employees' AND column_name = 'aadhaar_number'
  ) THEN
    ALTER TABLE employees ADD COLUMN aadhaar_number text;
  END IF;

  -- Add location column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'employees' AND column_name = 'location'
  ) THEN
    ALTER TABLE employees ADD COLUMN location text;
  END IF;

  -- Add date_of_birth column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'employees' AND column_name = 'date_of_birth'
  ) THEN
    ALTER TABLE employees ADD COLUMN date_of_birth date;
  END IF;
END $$;

-- Create function to generate next employee number
CREATE OR REPLACE FUNCTION generate_employee_number()
RETURNS text
LANGUAGE plpgsql
AS $$
DECLARE
  next_number integer;
  new_emp_number text;
BEGIN
  -- Get the highest existing employee number
  SELECT COALESCE(
    MAX(
      CAST(
        SUBSTRING(employee_number FROM 'CE-EMP-(\d+)') AS integer
      )
    ),
    0
  ) INTO next_number
  FROM employees
  WHERE employee_number IS NOT NULL;
  
  -- Increment and format
  next_number := next_number + 1;
  new_emp_number := 'CE-EMP-' || LPAD(next_number::text, 4, '0');
  
  RETURN new_emp_number;
END;
$$;

-- Create trigger to auto-generate employee number on insert
DROP TRIGGER IF EXISTS set_employee_number ON employees;

CREATE OR REPLACE FUNCTION set_employee_number()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  -- Only generate if employee_number is not provided
  IF NEW.employee_number IS NULL THEN
    NEW.employee_number := generate_employee_number();
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER set_employee_number
  BEFORE INSERT ON employees
  FOR EACH ROW
  EXECUTE FUNCTION set_employee_number();

-- Backfill employee numbers for existing employees
DO $$
DECLARE
  emp_record RECORD;
  counter integer := 1;
BEGIN
  FOR emp_record IN 
    SELECT id FROM employees WHERE employee_number IS NULL ORDER BY created_at
  LOOP
    UPDATE employees 
    SET employee_number = 'CE-EMP-' || LPAD(counter::text, 4, '0')
    WHERE id = emp_record.id;
    counter := counter + 1;
  END LOOP;
END $$;