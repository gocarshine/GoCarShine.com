/*
  # Recreate Super Admin User - Fixed Ambiguity

  1. Changes
    - Delete and recreate the super admin user properly
    - Fix column/variable ambiguity issues
    
  2. Security
    - Maintains all security policies
    - Properly sets up complete auth chain
*/

-- Clean up existing data completely
DO $$
BEGIN
  DELETE FROM public.user_roles WHERE user_roles.user_id = 'c14c193d-cab9-44ab-9872-9f33276f3316';
  DELETE FROM public.user_profiles WHERE user_profiles.id = 'c14c193d-cab9-44ab-9872-9f33276f3316';
  DELETE FROM auth.identities WHERE identities.user_id = 'c14c193d-cab9-44ab-9872-9f33276f3316';
  DELETE FROM auth.users WHERE users.id = 'c14c193d-cab9-44ab-9872-9f33276f3316';
END $$;

-- Now recreate everything properly
DO $$
DECLARE
  v_user_id uuid := 'c14c193d-cab9-44ab-9872-9f33276f3316';
  v_user_email text := 'prathvi.edu@gmail.com';
  v_user_password text := 'Prathvi1234@';
BEGIN
  -- Insert into auth.users
  INSERT INTO auth.users (
    id,
    instance_id,
    email,
    encrypted_password,
    email_confirmed_at,
    raw_app_meta_data,
    raw_user_meta_data,
    aud,
    role,
    created_at,
    updated_at,
    confirmation_token,
    email_change,
    email_change_token_new,
    recovery_token
  ) VALUES (
    v_user_id,
    '00000000-0000-0000-0000-000000000000',
    v_user_email,
    crypt(v_user_password, gen_salt('bf')),
    now(),
    '{"provider":"email","providers":["email"]}'::jsonb,
    '{"full_name":"Prathvi Admin"}'::jsonb,
    'authenticated',
    'authenticated',
    now(),
    now(),
    '',
    '',
    '',
    ''
  );

  -- Insert the identity
  INSERT INTO auth.identities (
    id,
    user_id,
    provider_id,
    identity_data,
    provider,
    last_sign_in_at,
    created_at,
    updated_at
  ) VALUES (
    v_user_id,
    v_user_id,
    v_user_id,
    jsonb_build_object(
      'sub', v_user_id::text,
      'email', v_user_email,
      'email_verified', true,
      'provider', 'email'
    ),
    'email',
    now(),
    now(),
    now()
  );

  -- Assign super_admin role
  INSERT INTO public.user_roles (user_id, role)
  VALUES (v_user_id, 'super_admin')
  ON CONFLICT (user_id) DO UPDATE SET role = 'super_admin';
  
END $$;
