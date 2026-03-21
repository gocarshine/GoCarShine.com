/*
  # Make created_by Nullable for Sample Data

  ## Overview
  This migration makes the created_by fields nullable on tables that require
  it for inserting sample/seed data. This allows data to exist before users
  are created through the auth system.

  ## Changes
  - Make created_by nullable on employees table
  - Make created_by nullable on expenses table  
  - Make created_by nullable on salary_payments table

  ## Notes
  - This is necessary for seeding sample data
  - Real production data should still track who created records
*/

-- Make created_by nullable on employees
ALTER TABLE employees ALTER COLUMN created_by DROP NOT NULL;

-- Make created_by nullable on expenses
ALTER TABLE expenses ALTER COLUMN created_by DROP NOT NULL;

-- Make created_by nullable on salary_payments
ALTER TABLE salary_payments ALTER COLUMN created_by DROP NOT NULL;
