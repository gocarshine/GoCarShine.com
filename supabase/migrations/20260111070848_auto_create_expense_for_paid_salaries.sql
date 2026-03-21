/*
  # Auto-create Expenses for Paid Salaries

  ## Overview
  This migration implements automatic expense tracking for salary payments.
  When a salary payment is marked as "paid", an expense record is automatically 
  created in the expenses table to maintain accurate financial records.

  ## Changes

  ### 1. Add expense_id reference to salary_payments
  - Add `expense_id` (uuid, nullable) - Links to auto-generated expense record
  - This allows tracking which expense was created for each salary payment

  ### 2. Create trigger function
  - Automatically creates expense record when salary payment_status = 'paid'
  - Updates expense if payment amount or date changes
  - Deletes expense if salary payment is deleted or status changes to pending

  ### 3. Expense Record Details
  - **Category**: 'Staff Salary'
  - **Expense Type**: 'daily' (recurring operational expense)
  - **Description**: "Salary: [Employee Name] - [Role] - [Month Year]"
  - **Amount**: Salary payment amount
  - **Date**: Payment date from salary record
  - **Area/Society**: Can be set based on employee assignment

  ## Benefits
  - Automatic financial tracking
  - No manual data entry needed
  - Consistent expense categorization
  - Complete audit trail
  - Real-time expense updates when salary status changes

  ## Important Notes
  - Only 'paid' salaries create expenses
  - 'pending' salaries do not create expenses
  - Changing status from paid to pending removes the expense
  - Deleting a salary payment also deletes the linked expense
*/

-- Add expense_id column to salary_payments table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'salary_payments' AND column_name = 'expense_id'
  ) THEN
    ALTER TABLE salary_payments ADD COLUMN expense_id uuid REFERENCES expenses(id) ON DELETE SET NULL;
  END IF;
END $$;

-- Create index for expense_id
CREATE INDEX IF NOT EXISTS idx_salary_payments_expense_id ON salary_payments(expense_id);

-- Add 'Staff Salary' category if not exists (we'll use this consistently)
-- Note: This doesn't modify the expenses table, just establishes the convention

-- Create function to automatically manage expense records for salary payments
CREATE OR REPLACE FUNCTION auto_manage_salary_expense()
RETURNS TRIGGER AS $$
DECLARE
  v_employee_name text;
  v_employee_role text;
  v_month_name text;
  v_expense_description text;
  v_expense_id uuid;
BEGIN
  -- Get employee details
  SELECT name, role INTO v_employee_name, v_employee_role
  FROM employees
  WHERE id = COALESCE(NEW.employee_id, OLD.employee_id);

  -- Format month name (e.g., "January 2026")
  v_month_name := TO_CHAR(COALESCE(NEW.salary_month, OLD.salary_month), 'Month YYYY');
  
  -- Create description
  v_expense_description := 'Salary: ' || v_employee_name || ' - ' || v_employee_role || ' - ' || v_month_name;

  -- Handle INSERT
  IF (TG_OP = 'INSERT') THEN
    -- Only create expense if payment is marked as paid
    IF NEW.payment_status = 'paid' THEN
      -- Create the expense record
      INSERT INTO expenses (
        expense_type,
        category,
        amount,
        description,
        expense_date,
        area_society,
        created_by
      ) VALUES (
        'daily',
        'Staff Salary',
        NEW.amount,
        v_expense_description,
        NEW.payment_date,
        NULL, -- Can be enhanced to link to employee area if needed
        NEW.created_by
      )
      RETURNING id INTO v_expense_id;

      -- Link the expense to salary payment
      NEW.expense_id := v_expense_id;
    END IF;
    RETURN NEW;
  END IF;

  -- Handle UPDATE
  IF (TG_OP = 'UPDATE') THEN
    -- Status changed from pending to paid: create expense
    IF OLD.payment_status = 'pending' AND NEW.payment_status = 'paid' THEN
      INSERT INTO expenses (
        expense_type,
        category,
        amount,
        description,
        expense_date,
        area_society,
        created_by
      ) VALUES (
        'daily',
        'Staff Salary',
        NEW.amount,
        v_expense_description,
        NEW.payment_date,
        NULL,
        NEW.created_by
      )
      RETURNING id INTO v_expense_id;

      NEW.expense_id := v_expense_id;

    -- Status changed from paid to pending: remove expense
    ELSIF OLD.payment_status = 'paid' AND NEW.payment_status = 'pending' THEN
      IF OLD.expense_id IS NOT NULL THEN
        DELETE FROM expenses WHERE id = OLD.expense_id;
        NEW.expense_id := NULL;
      END IF;

    -- Status is paid and details changed: update expense
    ELSIF NEW.payment_status = 'paid' AND OLD.expense_id IS NOT NULL THEN
      UPDATE expenses
      SET
        amount = NEW.amount,
        description = v_expense_description,
        expense_date = NEW.payment_date,
        updated_at = now()
      WHERE id = OLD.expense_id;

      NEW.expense_id := OLD.expense_id;
    END IF;

    RETURN NEW;
  END IF;

  -- Handle DELETE
  IF (TG_OP = 'DELETE') THEN
    -- Delete linked expense if exists
    IF OLD.expense_id IS NOT NULL THEN
      DELETE FROM expenses WHERE id = OLD.expense_id;
    END IF;
    RETURN OLD;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop trigger if exists and recreate
DROP TRIGGER IF EXISTS trigger_auto_manage_salary_expense ON salary_payments;

-- Create trigger for INSERT and UPDATE
CREATE TRIGGER trigger_auto_manage_salary_expense
  BEFORE INSERT OR UPDATE ON salary_payments
  FOR EACH ROW
  EXECUTE FUNCTION auto_manage_salary_expense();

-- Create trigger for DELETE (must be AFTER DELETE to access OLD values)
DROP TRIGGER IF EXISTS trigger_delete_salary_expense ON salary_payments;

CREATE TRIGGER trigger_delete_salary_expense
  AFTER DELETE ON salary_payments
  FOR EACH ROW
  EXECUTE FUNCTION auto_manage_salary_expense();

-- Backfill: Create expenses for existing paid salaries that don't have expense_id
DO $$
DECLARE
  v_salary_record RECORD;
  v_employee_name text;
  v_employee_role text;
  v_month_name text;
  v_expense_description text;
  v_expense_id uuid;
BEGIN
  FOR v_salary_record IN 
    SELECT sp.*, e.name as emp_name, e.role as emp_role
    FROM salary_payments sp
    JOIN employees e ON e.id = sp.employee_id
    WHERE sp.payment_status = 'paid' 
    AND sp.expense_id IS NULL
  LOOP
    -- Format month name
    v_month_name := TO_CHAR(v_salary_record.salary_month, 'Month YYYY');
    v_expense_description := 'Salary: ' || v_salary_record.emp_name || ' - ' || v_salary_record.emp_role || ' - ' || v_month_name;

    -- Create expense
    INSERT INTO expenses (
      expense_type,
      category,
      amount,
      description,
      expense_date,
      created_by
    ) VALUES (
      'daily',
      'Staff Salary',
      v_salary_record.amount,
      v_expense_description,
      v_salary_record.payment_date,
      v_salary_record.created_by
    )
    RETURNING id INTO v_expense_id;

    -- Update salary payment with expense link
    UPDATE salary_payments
    SET expense_id = v_expense_id
    WHERE id = v_salary_record.id;
  END LOOP;
END $$;