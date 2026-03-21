/*
  # Enhance Expense and Salary Management

  ## Overview
  This migration enhances the expense and salary management system with:
  - Area/Society tracking for expenses
  - Bill upload support for expenses
  - Month-wise salary tracking with payment status
  - Prevention of duplicate salary entries per employee per month

  ## Changes to Existing Tables

  ### 1. `expenses` table updates
  - Add `area_society` (text) - Area or society where expense occurred
  - Add `bill_url` (text, nullable) - URL to uploaded bill/receipt

  ### 2. `salary_payments` table restructure
  - Add `salary_month` (date) - Month for which salary is being paid (YYYY-MM-01 format)
  - Add `payment_status` (text) - Payment status: 'paid' or 'pending'
  - Add unique constraint to prevent duplicate entries for same employee + month
  - Modify remarks to be more detailed

  ## Important Notes
  - Expense date field is already mandatory (NOT NULL)
  - Salary month should be stored as first day of the month (e.g., 2026-01-01 for January 2026)
  - Unique constraint ensures one salary record per employee per month
*/

-- Add new columns to expenses table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'expenses' AND column_name = 'area_society'
  ) THEN
    ALTER TABLE expenses ADD COLUMN area_society text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'expenses' AND column_name = 'bill_url'
  ) THEN
    ALTER TABLE expenses ADD COLUMN bill_url text;
  END IF;
END $$;

-- Add new columns to salary_payments table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'salary_payments' AND column_name = 'salary_month'
  ) THEN
    ALTER TABLE salary_payments ADD COLUMN salary_month date NOT NULL DEFAULT DATE_TRUNC('month', CURRENT_DATE);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'salary_payments' AND column_name = 'payment_status'
  ) THEN
    ALTER TABLE salary_payments ADD COLUMN payment_status text NOT NULL DEFAULT 'paid' CHECK (payment_status IN ('paid', 'pending'));
  END IF;
END $$;

-- Create unique constraint to prevent duplicate salary entries per employee per month
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'unique_employee_salary_month'
  ) THEN
    ALTER TABLE salary_payments
    ADD CONSTRAINT unique_employee_salary_month UNIQUE (employee_id, salary_month);
  END IF;
END $$;

-- Add index for salary_month for efficient filtering
CREATE INDEX IF NOT EXISTS idx_salary_payments_month ON salary_payments(salary_month DESC);
CREATE INDEX IF NOT EXISTS idx_salary_payments_status ON salary_payments(payment_status);

-- Add index for area_society in expenses
CREATE INDEX IF NOT EXISTS idx_expenses_area_society ON expenses(area_society);