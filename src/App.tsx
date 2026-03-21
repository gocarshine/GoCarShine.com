import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './context/AuthContext';
import { supabase } from './lib/supabase';
import { useAndroidBackButton } from './hooks/useCapacitor';
import ScrollProgressBar from './components/ScrollProgressBar';
import FloatingTabs from './components/FloatingTabs';
import Home from './pages/Home';
import Login from './pages/Login';
import Signup from './pages/Signup';
import Dashboard from './pages/Dashboard';
import CarDetailsBooking from './pages/CarDetailsBooking';
import AdminLogin from './pages/AdminLogin';
import AdminDashboard from './pages/AdminDashboard';
import AdminBookings from './pages/AdminBookings';
import AdminUsers from './pages/AdminUsers';
import AdminEnquiries from './pages/AdminEnquiries';
import AdminSingleWash from './pages/AdminSingleWash';
import AdminEmployees from './pages/AdminEmployees';
import AdminExpenses from './pages/AdminExpenses';
import AdminReports from './pages/AdminReports';
import AdminSalary from './pages/AdminSalary';
import AdminAttendance from './pages/AdminAttendance';
import AdminLeave from './pages/AdminLeave';
import AdminDeletedBookings from './pages/AdminDeletedBookings';

function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const { user, loading } = useAuth();

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-[#00bcd4] to-[#000000] flex items-center justify-center">
        <div className="text-white text-xl">Loading...</div>
      </div>
    );
  }

  if (!user) {
    return <Navigate to="/login" replace />;
  }

  return <>{children}</>;
}

function AdminRoute({ children }: { children: React.ReactNode }) {
  const { user, loading } = useAuth();

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-[#00bcd4] to-[#000000] flex items-center justify-center">
        <div className="text-white text-xl">Loading...</div>
      </div>
    );
  }

  if (!user) {
    return <Navigate to="/admin/login" replace />;
  }

  return <>{children}</>;
}

function App() {
  useAndroidBackButton();

  return (
    <Router>
      <AuthProvider>
        <ScrollProgressBar />
        <FloatingTabs />
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/login" element={<Login />} />
          <Route path="/signup" element={<Signup />} />
          <Route path="/car-details" element={<CarDetailsBooking />} />
          <Route
            path="/dashboard"
            element={
              <ProtectedRoute>
                <Dashboard />
              </ProtectedRoute>
            }
          />

          <Route path="/admin/login" element={<AdminLogin />} />
          <Route
            path="/admin/dashboard"
            element={
              <AdminRoute>
                <AdminDashboard />
              </AdminRoute>
            }
          />
          <Route
            path="/admin/bookings"
            element={
              <AdminRoute>
                <AdminBookings />
              </AdminRoute>
            }
          />
          <Route
            path="/admin/deleted-bookings"
            element={
              <AdminRoute>
                <AdminDeletedBookings />
              </AdminRoute>
            }
          />
          <Route
            path="/admin/users"
            element={
              <AdminRoute>
                <AdminUsers />
              </AdminRoute>
            }
          />
          <Route
            path="/admin/enquiries"
            element={
              <AdminRoute>
                <AdminEnquiries />
              </AdminRoute>
            }
          />
          <Route
            path="/admin/single-wash"
            element={
              <AdminRoute>
                <AdminSingleWash />
              </AdminRoute>
            }
          />
          <Route
            path="/admin/employees"
            element={
              <AdminRoute>
                <AdminEmployees />
              </AdminRoute>
            }
          />
          <Route
            path="/admin/attendance"
            element={
              <AdminRoute>
                <AdminAttendance />
              </AdminRoute>
            }
          />
          <Route
            path="/admin/leave"
            element={
              <AdminRoute>
                <AdminLeave />
              </AdminRoute>
            }
          />
          <Route
            path="/admin/salary"
            element={
              <AdminRoute>
                <AdminSalary />
              </AdminRoute>
            }
          />
          <Route
            path="/admin/expenses"
            element={
              <AdminRoute>
                <AdminExpenses />
              </AdminRoute>
            }
          />
          <Route
            path="/admin/reports"
            element={
              <AdminRoute>
                <AdminReports />
              </AdminRoute>
            }
          />

          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </AuthProvider>
    </Router>
  );
}

export default App;
