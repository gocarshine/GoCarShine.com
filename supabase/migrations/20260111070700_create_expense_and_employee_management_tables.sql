/*
  # Create Expense and Employee Management Tables

  ## Overview
  This migration creates a comprehensive expense tracking and employee management system 
  for admin users to maintain financial records and employee information.

  ## New Tables

  ### 1. `expenses`
  Tracks all operational expenses (daily and one-time)
  - `id` (uuid, primary key) - Unique expense identifier
  - `expense_type` (text) - Type: 'daily' or 'one_time'
  - `category` (text) - Expense category (e.g., 'cleaning_supplies', 'equipment', 'marketing')
  - `amount` (numeric) - Expense amount
  - `description` (text) - Detailed description
  - `expense_date` (date) - Date of expense
  - `created_by` (uuid) - Admin user who created the record
  - `created_at` (timestamptz) - Record creation timestamp
  - `updated_at` (timestamptz) - Last update timestamp

  ### 2. `employees`
  Maintains employee records and details
  - `id` (uuid, primary key) - Unique employee identifier
  - `name` (text) - Employee full name
  - `role` (text) - Job role/designation
  - `joining_date` (date) - Date of joining
  - `status` (text) - Employment status: 'active' or 'inactive'
  - `salary_type` (text) - Payment frequency: 'monthly', 'weekly', or 'contract'
  - `salary_amount` (numeric) - Base salary amount
  - `contact_no` (text) - Contact phone number
  - `email` (text) - Email address
  - `created_by` (uuid) - Admin user who created the record
  - `created_at` (timestamptz) - Record creation timestamp
  - `updated_at` (timestamptz) - Last update timestamp

  ### 3. `salary_payments`
  Tracks salary payment history for employees
  - `id` (uuid, primary key) - Unique payment identifier
  - `employee_id` (uuid) - References employees table
  - `payment_date` (date) - Date of salary payment
  - `amount` (numeric) - Payment amount
  - `remarks` (text) - Additional notes or remarks
  - `created_by` (uuid) - Admin user who recorded the payment
  - `created_at` (timestamptz) - Record creation timestamp

  ## Security
  - Enable RLS on all three tables
  - Admin-only access for all operations (SELECT, INSERT, UPDATE, DELETE)
  - Uses is_admin(auth.uid()) function to verify admin privileges

  ## Indexes
  - Expense date and type indexes for efficient filtering
  - Employee status index for active/inactive queries
  - Salary payment employee_id index for payment history retrieval
*/

-- Create expenses table
CREATE TABLE IF NOT EXISTS expenses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  expense_type text NOT NULL CHECK (expense_type IN ('daily', 'one_time')),
  category text NOT NULL,
  amount numeric(10, 2) NOT NULL CHECK (amount > 0),
  description text NOT NULL,
  expense_date date NOT NULL DEFAULT CURRENT_DATE,
  created_by uuid REFERENCES auth.users(id) NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create employees table
CREATE TABLE IF NOT EXISTS employees (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  role text NOT NULL,
  joining_date date NOT NULL,
  status text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
  salary_type text NOT NULL CHECK (salary_type IN ('monthly', 'weekly', 'contract')),
  salary_amount numeric(10, 2) NOT NULL CHECK (salary_amount >= 0),
  contact_no text,
  email text,
  created_by uuid REFERENCES auth.users(id) NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create salary_payments table
CREATE TABLE IF NOT EXISTS salary_payments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  employee_id uuid REFERENCES employees(id) ON DELETE CASCADE NOT NULL,
  payment_date date NOT NULL DEFAULT CURRENT_DATE,
  amount numeric(10, 2) NOT NULL CHECK (amount > 0),
  remarks text,
  created_by uuid REFERENCES auth.users(id) NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_expenses_date ON expenses(expense_date DESC);
CREATE INDEX IF NOT EXISTS idx_expenses_type ON expenses(expense_type);
CREATE INDEX IF NOT EXISTS idx_expenses_category ON expenses(category);
CREATE INDEX IF NOT EXISTS idx_employees_status ON employees(status);
CREATE INDEX IF NOT EXISTS idx_salary_payments_employee ON salary_payments(employee_id);
CREATE INDEX IF NOT EXISTS idx_salary_payments_date ON salary_payments(payment_date DESC);

-- Enable Row Level Security
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE salary_payments ENABLE ROW LEVEL SECURITY;

-- RLS Policies for expenses table (admin-only access)
CREATE POLICY "Admins can view all expenses"
  ON expenses FOR SELECT
  TO authenticated
  USING (is_admin(auth.uid()));

CREATE POLICY "Admins can insert expenses"
  ON expenses FOR INSERT
  TO authenticated
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "Admins can update expenses"
  ON expenses FOR UPDATE
  TO authenticated
  USING (is_admin(auth.uid()))
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "Admins can delete expenses"
  ON expenses FOR DELETE
  TO authenticated
  USING (is_admin(auth.uid()));

-- RLS Policies for employees table (admin-only access)
CREATE POLICY "Admins can view all employees"
  ON employees FOR SELECT
  TO authenticated
  USING (is_admin(auth.uid()));

CREATE POLICY "Admins can insert employees"
  ON employees FOR INSERT
  TO authenticated
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "Admins can update employees"
  ON employees FOR UPDATE
  TO authenticated
  USING (is_admin(auth.uid()))
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "Admins can delete employees"
  ON employees FOR DELETE
  TO authenticated
  USING (is_admin(auth.uid()));

-- RLS Policies for salary_payments table (admin-only access)
CREATE POLICY "Admins can view all salary payments"
  ON salary_payments FOR SELECT
  TO authenticated
  USING (is_admin(auth.uid()));

CREATE POLICY "Admins can insert salary payments"
  ON salary_payments FOR INSERT
  TO authenticated
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "Admins can update salary payments"
  ON salary_payments FOR UPDATE
  TO authenticated
  USING (is_admin(auth.uid()))
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "Admins can delete salary payments"
  ON salary_payments FOR DELETE
  TO authenticated
  USING (is_admin(auth.uid()));