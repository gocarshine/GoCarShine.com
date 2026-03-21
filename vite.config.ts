import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  optimizeDeps: {
    exclude: ['lucide-react'],
  },
  define: {
    'import.meta.env.VITE_SUPABASE_URL': JSON.stringify('https://tmlbfheevoxptwypnyal.supabase.co'),
    'import.meta.env.VITE_SUPABASE_ANON_KEY': JSON.stringify('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRtbGJmaGVldm94cHR3eXBueWFsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgwOTg5NzgsImV4cCI6MjA4MzY3NDk3OH0.6DkEjEU8EwzO3dBmXpK-Z1QvszNlXQIk0rC7rda3IIQ'),
  },
});
