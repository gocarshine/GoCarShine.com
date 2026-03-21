/*
  # Add Monthly Expense Type

  ## Overview
  This migration adds 'monthly' as a valid expense type option alongside 
  existing 'daily' and 'one_time' types.

  ## Changes
  1. Modify the expense_type CHECK constraint to include 'monthly'
  2. This allows tracking of recurring monthly expenses like rent, subscriptions, etc.

  ## Valid Expense Types After Migration
  - 'daily' - Daily operational expenses
  - 'one_time' - One-time or ad-hoc expenses
  - 'monthly' - Monthly recurring expenses
*/

-- Drop the existing constraint
ALTER TABLE expenses DROP CONSTRAINT IF EXISTS expenses_expense_type_check;

-- Add new constraint that includes 'monthly' as valid option
ALTER TABLE expenses 
ADD CONSTRAINT expenses_expense_type_check 
CHECK (expense_type IN ('daily', 'one_time', 'monthly'));