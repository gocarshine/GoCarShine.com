/*
  # Update Salary Expenses to Monthly Type with Salary Month

  ## Overview
  This migration updates the auto_manage_salary_expense trigger function to:
  - Create expenses with 'monthly' type instead of 'daily'
  - Store the salary month (formatted as "Month YYYY") in the area_society field
  - This allows proper categorization and tracking of salary expenses by month

  ## Changes
  1. Update trigger function to use 'monthly' expense type
  2. Store formatted salary month in area_society field for salary expenses
  3. This change applies to all new salary payments and updates existing ones if edited

  ## Benefits
  - Proper categorization of salary expenses as monthly recurring costs
  - Easy filtering by salary month in expense reports
  - Better expense tracking and analysis
*/

-- Recreate the trigger function with updated logic
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
      -- Create the expense record with MONTHLY type
      INSERT INTO expenses (
        expense_type,
        category,
        amount,
        description,
        expense_date,
        area_society,
        created_by
      ) VALUES (
        'monthly',  -- Changed from 'daily' to 'monthly'
        'Staff Salary',
        NEW.amount,
        v_expense_description,
        NEW.payment_date,
        v_month_name,  -- Store salary month in area_society field
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
        'monthly',  -- Changed from 'daily' to 'monthly'
        'Staff Salary',
        NEW.amount,
        v_expense_description,
        NEW.payment_date,
        v_month_name,  -- Store salary month in area_society field
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
        expense_type = 'monthly',  -- Ensure it's monthly type
        amount = NEW.amount,
        description = v_expense_description,
        expense_date = NEW.payment_date,
        area_society = v_month_name,  -- Update salary month
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

-- Update existing salary-related expenses to monthly type
UPDATE expenses
SET 
  expense_type = 'monthly',
  area_society = TO_CHAR(
    (SELECT salary_month FROM salary_payments WHERE expense_id = expenses.id),
    'Month YYYY'
  )
WHERE category = 'Staff Salary' 
AND expense_type = 'daily'
AND id IN (SELECT expense_id FROM salary_payments WHERE expense_id IS NOT NULL);