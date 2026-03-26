import { useState } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { supabase } from '../lib/supabase';

export default function CarDetailsBooking() {
  const navigate = useNavigate();
  const location = useLocation();
  const { user } = useAuth();
  const bookingData = location.state?.bookingData;

  const [carDetails, setCarDetails] = useState({
    carModel: '',
    carNumber: '',
    carColor: ''
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  if (!bookingData) {
    navigate('/');
    return null;
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      const { error: insertError } = await supabase
        .from('bookings')
        .insert([{
          user_id: user?.id,
          customer_name: bookingData.customer_name,
          package_name: bookingData.package_name,
          package_price: bookingData.package_price,
          package_period: bookingData.package_period,
          car_size: bookingData.car_size,
          contact_no: bookingData.contact_no,
          email: bookingData.email,
          location: bookingData.location,
          address: bookingData.address,
          preferred_time_slot: bookingData.preferred_time_slot,
          car_model: carDetails.carModel,
          car_number: carDetails.carNumber,
          car_color: carDetails.carColor,
          status: 'pending'
        }]);

      if (insertError) throw insertError;

      navigate('/dashboard');
    } catch (err: any) {
      setError(err.message || 'Failed to submit booking');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-white flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl shadow-2xl p-8 w-full max-w-2xl">
        <h1 className="text-3xl font-bold text-gray-900 mb-6">Step 2: Car Details</h1>

        {error && (
          <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg mb-4">
            {error}
          </div>
        )}

        <form onSubmit={handleSubmit} className="space-y-6">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Car Model *
            </label>
            <input
              type="text"
              required
              value={carDetails.carModel}
              onChange={(e) => setCarDetails({ ...carDetails, carModel: e.target.value })}
              className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              placeholder="e.g., Honda City"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Car Number *
            </label>
            <input
              type="text"
              required
              value={carDetails.carNumber}
              onChange={(e) => setCarDetails({ ...carDetails, carNumber: e.target.value })}
              className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              placeholder="e.g., DL01AB1234"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Car Color *
            </label>
            <input
              type="text"
              required
              value={carDetails.carColor}
              onChange={(e) => setCarDetails({ ...carDetails, carColor: e.target.value })}
              className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              placeholder="e.g., White"
            />
          </div>

          <div className="flex gap-4">
            <button
              type="button"
              onClick={() => navigate('/')}
              className="flex-1 px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-all font-semibold"
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={loading}
              className="flex-1 px-6 py-3 bg-gradient-to-r from-blue-600 to-blue-700 text-white rounded-lg hover:from-blue-500 hover:to-blue-600 transition-all font-semibold disabled:opacity-50"
            >
              {loading ? 'Submitting...' : 'Complete Booking'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
