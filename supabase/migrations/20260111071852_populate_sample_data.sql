/*
  # Populate Sample Data for Testing

  ## Overview
  This migration adds sample data across all tables for testing and demonstration.

  ## Data Created
  - 4 sample employees with different roles and statuses
  - 3 package bookings with various statuses
  - 3 single wash bookings
  - 5 expense records (daily, one-time, monthly)
  - 3 salary payment records
  - 9 attendance records (3 days for 3 employees)
  - 3 leave requests with different statuses
  - 3 customer enquiries

  ## Notes
  - All sample data uses realistic Indian names and locations
  - Dates are relative to current date for relevance
  - This data is for testing only
*/

DO $$
DECLARE
  emp1_id uuid := gen_random_uuid();
  emp2_id uuid := gen_random_uuid();
  emp3_id uuid := gen_random_uuid();
  emp4_id uuid := gen_random_uuid();
BEGIN
  
  -- Insert sample employees
  INSERT INTO employees (id, name, role, joining_date, status, salary_type, salary_amount, contact_no, email, location, date_of_birth)
  VALUES
    (emp1_id, 'Rajesh Kumar', 'Car Washer', '2024-01-15', 'active', 'monthly', 15000, '+91-9876543210', 'rajesh.kumar@example.com', 'Whitefield', '1995-03-20'),
    (emp2_id, 'Priya Sharma', 'Senior Car Washer', '2023-06-01', 'active', 'monthly', 18000, '+91-9876543211', 'priya.sharma@example.com', 'Marathahalli', '1992-07-15'),
    (emp3_id, 'Mohammed Ali', 'Supervisor', '2023-01-10', 'active', 'monthly', 25000, '+91-9876543212', 'ali@example.com', 'HSR Layout', '1990-11-05'),
    (emp4_id, 'Lakshmi Reddy', 'Car Washer', '2024-06-20', 'inactive', 'monthly', 14000, '+91-9876543213', 'lakshmi@example.com', 'Koramangala', '1998-02-28');

  -- Insert sample bookings
  INSERT INTO bookings (
    package_name, package_price, package_period, car_size, customer_name,
    contact_no, email, address, license_plate, car_model, car_parking_number,
    wash_type, preferred_time_slot, status, location, payment_reference,
    expiry_date, created_at
  )
  VALUES
    ('Premium Package', 3999, '3 months', 'sedan', 'Amit Patel', '+91-9988776655', 'amit.patel@example.com', 
     'Prestige Sunrise Park, Whitefield', 'KA-01-AB-1234', 'Honda City', 'A-101', 
     'internal_external', 'Morning (8AM-11AM)', 'confirmed', 'Whitefield', 'PAY-2024-001', 
     CURRENT_DATE + INTERVAL '90 days', CURRENT_DATE - INTERVAL '5 days'),
    
    ('Standard Package', 2499, '2 months', 'hatchback', 'Sneha Reddy', '+91-9988776656', 'sneha.reddy@example.com',
     'Mantri Euphoria, HSR Layout', 'KA-01-CD-5678', 'Maruti Swift', 'B-205',
     'external', 'Afternoon (12PM-3PM)', 'pending', 'HSR Layout', 'PAY-2024-002',
     CURRENT_DATE + INTERVAL '60 days', CURRENT_DATE - INTERVAL '2 days'),
    
    ('Deluxe Package', 5999, '6 months', 'suv', 'Karthik Iyer', '+91-9988776657', 'karthik.iyer@example.com',
     'Brigade Cosmopolis, Whitefield', 'KA-01-EF-9012', 'Toyota Fortuner', 'C-310',
     'internal_external', 'Evening (4PM-7PM)', 'confirmed', 'Whitefield', 'PAY-2024-003',
     CURRENT_DATE + INTERVAL '180 days', CURRENT_DATE - INTERVAL '10 days');

  -- Insert single wash bookings
  INSERT INTO single_wash_bookings (
    name, mobile, car_model, car_number, wash_type, price, booking_date,
    preferred_time_slot, location, status, payment_reference
  )
  VALUES
    ('Deepak Singh', '+91-9876543220', 'Hyundai Creta', 'KA-01-GH-3456', 'internal_external', 350,
     CURRENT_DATE, 'Morning (8AM-11AM)', 'Marathahalli', 'completed', 'PAY-SW-001'),
    
    ('Anita Desai', '+91-9876543221', 'Maruti Baleno', 'KA-01-IJ-7890', 'external', 250,
     CURRENT_DATE + INTERVAL '1 day', 'Afternoon (12PM-3PM)', 'Koramangala', 'confirmed', 'PAY-SW-002'),
    
    ('Vikram Mehta', '+91-9876543222', 'Honda Civic', 'KA-01-KL-2345', 'internal_external', 350,
     CURRENT_DATE - INTERVAL '1 day', 'Evening (4PM-7PM)', 'Whitefield', 'completed', 'PAY-SW-003');

  -- Insert expenses
  INSERT INTO expenses (
    expense_type, category, amount, description, expense_date, area_society
  )
  VALUES
    ('daily', 'Cleaning Supplies', 1500.00, 'Car shampoo, wax, and microfiber cloths', 
     CURRENT_DATE - INTERVAL '3 days', 'Whitefield'),
    
    ('one_time', 'Equipment', 8500.00, 'High-pressure water pump', 
     CURRENT_DATE - INTERVAL '15 days', 'Main Office'),
    
    ('daily', 'Transportation', 500.00, 'Fuel for service vehicle', 
     CURRENT_DATE - INTERVAL '1 day', 'Marathahalli'),
    
    ('monthly', 'Rent', 15000.00, 'Office space rent for January 2026', 
     CURRENT_DATE - INTERVAL '5 days', 'Main Office'),
    
    ('daily', 'Utilities', 800.00, 'Water and electricity charges', 
     CURRENT_DATE - INTERVAL '2 days', 'Whitefield');

  -- Insert salary payments for current month
  INSERT INTO salary_payments (
    employee_id, payment_date, amount, salary_month, payment_status, remarks
  )
  VALUES
    (emp1_id, CURRENT_DATE - INTERVAL '5 days', 15000.00, 
     DATE_TRUNC('month', CURRENT_DATE), 'paid', 'Salary for January 2026'),
    
    (emp2_id, CURRENT_DATE - INTERVAL '5 days', 18000.00,
     DATE_TRUNC('month', CURRENT_DATE), 'paid', 'Salary for January 2026'),
    
    (emp3_id, CURRENT_DATE - INTERVAL '5 days', 25000.00,
     DATE_TRUNC('month', CURRENT_DATE), 'paid', 'Salary for January 2026');

  -- Insert attendance records for the past 3 days
  INSERT INTO attendance (
    employee_id, attendance_date, status, check_in_time, check_out_time, remarks
  )
  VALUES
    (emp1_id, CURRENT_DATE - INTERVAL '1 day', 'present', '09:00', '18:00', 'Regular shift'),
    (emp2_id, CURRENT_DATE - INTERVAL '1 day', 'present', '09:15', '18:30', 'Regular shift'),
    (emp3_id, CURRENT_DATE - INTERVAL '1 day', 'present', '08:45', '17:45', 'Regular shift'),
    
    (emp1_id, CURRENT_DATE - INTERVAL '2 days', 'present', '09:00', '18:00', 'Regular shift'),
    (emp2_id, CURRENT_DATE - INTERVAL '2 days', 'half_day', '09:15', '13:00', 'Left early for personal work'),
    (emp3_id, CURRENT_DATE - INTERVAL '2 days', 'present', '08:45', '17:45', 'Regular shift'),
    
    (emp1_id, CURRENT_DATE - INTERVAL '3 days', 'present', '09:00', '18:00', 'Regular shift'),
    (emp2_id, CURRENT_DATE - INTERVAL '3 days', 'present', '09:15', '18:30', 'Regular shift'),
    (emp3_id, CURRENT_DATE - INTERVAL '3 days', 'present', '08:45', '17:45', 'Regular shift');

  -- Insert leave requests
  INSERT INTO leave_requests (
    employee_id, leave_type, from_date, to_date, reason, status, admin_remarks
  )
  VALUES
    (emp1_id, 'casual', CURRENT_DATE + INTERVAL '5 days', CURRENT_DATE + INTERVAL '6 days',
     'Family function', 'approved', 'Approved'),
    
    (emp2_id, 'sick', CURRENT_DATE + INTERVAL '3 days', CURRENT_DATE + INTERVAL '3 days',
     'Doctor appointment', 'pending', ''),
    
    (emp3_id, 'paid', CURRENT_DATE + INTERVAL '10 days', CURRENT_DATE + INTERVAL '15 days',
     'Vacation', 'approved', 'Approved for vacation');

  -- Insert enquiries
  INSERT INTO enquiries (name, mobile, message, status, created_at)
  VALUES
    ('Rahul Verma', '+91-9876543230', 'I want to know about monthly packages for SUV', 'pending', 
     CURRENT_DATE - INTERVAL '1 day'),
    
    ('Pooja Nair', '+91-9876543231', 'Do you provide service in Indiranagar area?', 'pending',
     CURRENT_DATE - INTERVAL '3 days'),
    
    ('Suresh Babu', '+91-9876543232', 'What are your timings for weekend service?', 'pending',
     CURRENT_DATE - INTERVAL '6 hours');

END $$;
