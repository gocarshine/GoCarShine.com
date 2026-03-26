import { useState, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { supabase } from '../lib/supabase';

export default function AdminDashboard() {
  const { signOut } = useAuth();
  const navigate = useNavigate();
  const [stats, setStats] = useState({
    totalBookings: 0,
    activeBookings: 0,
    totalUsers: 0,
    totalRevenue: 0
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchStats();
  }, []);

  const fetchStats = async () => {
    try {
      const [bookingsRes, usersRes] = await Promise.all([
        supabase.from('bookings').select('*', { count: 'exact' }),
        supabase.from('user_profiles').select('*', { count: 'exact' })
      ]);

      const activeBookings = bookingsRes.data?.filter(b => b.status === 'active').length || 0;
      const totalRevenue = bookingsRes.data?.reduce((sum, b) => sum + (b.package_price || 0), 0) || 0;

      setStats({
        totalBookings: bookingsRes.count || 0,
        activeBookings,
        totalUsers: usersRes.count || 0,
        totalRevenue
      });
    } catch (error) {
      console.error('Error fetching stats:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleLogout = async () => {
    await signOut();
    navigate('/admin/login');
  };

  return (
    <div className="min-h-screen bg-gray-100">
      <nav className="bg-white shadow-md">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex justify-between items-center">
            <h1 className="text-2xl font-bold text-gray-900">Admin Dashboard</h1>
            <button
              onClick={handleLogout}
              className="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg transition-colors"
            >
              Logout
            </button>
          </div>
        </div>
      </nav>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <div className="bg-white rounded-lg shadow p-6">
            <h3 className="text-gray-500 text-sm font-medium">Total Bookings</h3>
            <p className="text-3xl font-bold text-gray-900 mt-2">{stats.totalBookings}</p>
          </div>
          <div className="bg-white rounded-lg shadow p-6">
            <h3 className="text-gray-500 text-sm font-medium">Active Bookings</h3>
            <p className="text-3xl font-bold text-gray-900 mt-2">{stats.activeBookings}</p>
          </div>
          <div className="bg-white rounded-lg shadow p-6">
            <h3 className="text-gray-500 text-sm font-medium">Total Users</h3>
            <p className="text-3xl font-bold text-gray-900 mt-2">{stats.totalUsers}</p>
          </div>
          <div className="bg-white rounded-lg shadow p-6">
            <h3 className="text-gray-500 text-sm font-medium">Total Revenue</h3>
            <p className="text-3xl font-bold text-gray-900 mt-2">₹{stats.totalRevenue.toLocaleString()}</p>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <Link to="/admin/bookings" className="bg-white rounded-lg shadow p-6 hover:shadow-lg transition-shadow">
            <h3 className="text-xl font-bold text-gray-900 mb-2">Manage Bookings</h3>
            <p className="text-gray-600">View and manage all bookings</p>
          </Link>
          <Link to="/admin/users" className="bg-white rounded-lg shadow p-6 hover:shadow-lg transition-shadow">
            <h3 className="text-xl font-bold text-gray-900 mb-2">Manage Users</h3>
            <p className="text-gray-600">View and manage user accounts</p>
          </Link>
          <Link to="/admin/enquiries" className="bg-white rounded-lg shadow p-6 hover:shadow-lg transition-shadow">
            <h3 className="text-xl font-bold text-gray-900 mb-2">Enquiries</h3>
            <p className="text-gray-600">View customer enquiries</p>
          </Link>
          <Link to="/admin/single-wash" className="bg-white rounded-lg shadow p-6 hover:shadow-lg transition-shadow">
            <h3 className="text-xl font-bold text-gray-900 mb-2">Single Wash Bookings</h3>
            <p className="text-gray-600">Manage single wash services</p>
          </Link>
          <Link to="/admin/employees" className="bg-white rounded-lg shadow p-6 hover:shadow-lg transition-shadow">
            <h3 className="text-xl font-bold text-gray-900 mb-2">Employees</h3>
            <p className="text-gray-600">Manage employee records</p>
          </Link>
          <Link to="/admin/reports" className="bg-white rounded-lg shadow p-6 hover:shadow-lg transition-shadow">
            <h3 className="text-xl font-bold text-gray-900 mb-2">Reports</h3>
            <p className="text-gray-600">View business reports</p>
          </Link>
        </div>
      </div>
    </div>
  );
}
