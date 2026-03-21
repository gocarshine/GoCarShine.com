import { useState } from 'react';
import { X } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../context/AuthContext';

interface SingleWashBookingModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export const SingleWashBookingModal = ({ isOpen, onClose }: SingleWashBookingModalProps) => {
  const { user } = useAuth();
  const [formData, setFormData] = useState({
    name: '',
    mobile: '',
    carModel: '',
    carNumber: '',
    washType: 'external',
    bookingDate: '',
    preferredTimeSlot: '',
    location: ''
  });
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitSuccess, setSubmitSuccess] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    setIsSubmitting(true);

    try {
      const price = formData.washType === 'external' ? 250 : 350;

      const { error } = await supabase
        .from('single_wash_bookings')
        .insert([{
          user_id: user?.id || null,
          name: formData.name,
          mobile: formData.mobile,
          car_model: formData.carModel,
          car_number: formData.carNumber,
          wash_type: formData.washType,
          price: price,
          booking_date: formData.bookingDate,
          preferred_time_slot: formData.preferredTimeSlot,
          location: formData.location,
          status: 'pending'
        }]);

      if (error) throw error;

      setSubmitSuccess(true);
      setFormData({
        name: '',
        mobile: '',
        carModel: '',
        carNumber: '',
        washType: 'external',
        bookingDate: '',
        preferredTimeSlot: '',
        location: ''
      });

      setTimeout(() => {
        setSubmitSuccess(false);
        onClose();
      }, 3000);
    } catch (error: any) {
      console.error('Error submitting booking:', error);
      const errorMessage = error?.message || 'Unknown error occurred';
      alert(`Failed to submit booking: ${errorMessage}. Please try again.`);
    } finally {
      setIsSubmitting(false);
    }
  };

  if (!isOpen) return null;

  const price = formData.washType === 'external' ? 250 : 350;

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-start justify-center z-50 p-2 sm:p-4 overflow-y-auto pt-4 sm:pt-8">
      <div className="bg-white rounded-xl shadow-2xl max-w-2xl w-full mb-4">
        <div className="sticky top-0 bg-white border-b border-gray-200 px-4 sm:px-6 py-3 sm:py-4 flex items-center justify-between">
          <h2 className="text-lg sm:text-xl md:text-2xl font-bold text-gray-900">Book Single Wash Service</h2>
          <button
            onClick={onClose}
            className="text-gray-500 hover:text-gray-700 transition-colors"
            disabled={isSubmitting}
          >
            <X className="w-6 h-6" />
          </button>
        </div>

        {submitSuccess ? (
          <div className="p-12 text-center">
            <div className="w-20 h-20 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-6 animate-bounce">
              <svg className="w-10 h-10 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
              </svg>
            </div>
            <h3 className="text-2xl font-bold text-gray-900 mb-3">Booking Confirmed!</h3>
            <p className="text-gray-600 text-lg mb-2">Your single wash service has been booked successfully.</p>
            <p className="text-gray-500 text-sm">We will contact you shortly to confirm the appointment.</p>
            <div className="mt-6 p-4 bg-green-50 rounded-lg border border-green-200">
              <p className="text-green-800 font-semibold">Thank you for choosing GoCarShine!</p>
              <p className="text-green-700 text-sm mt-1">Check your dashboard to view booking details.</p>
            </div>
          </div>
        ) : (
          <form onSubmit={handleSubmit} className="p-3 sm:p-5 space-y-2 sm:space-y-3">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-2 sm:gap-3">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Full Name *
                </label>
                <input
                  type="text"
                  required
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#ff8c00] focus:border-transparent text-gray-900 bg-white"
                  placeholder="Enter your name"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Mobile Number *
                </label>
                <input
                  type="tel"
                  required
                  value={formData.mobile}
                  onChange={(e) => {
                    const value = e.target.value.replace(/\D/g, '');
                    if (value.length <= 10) {
                      setFormData({ ...formData, mobile: value });
                    }
                  }}
                  pattern="[6-9][0-9]{9}"
                  maxLength={10}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#ff8c00] focus:border-transparent text-gray-900 bg-white"
                  placeholder="Enter 10-digit mobile number"
                />
                {formData.mobile && formData.mobile.length > 0 && (
                  <>
                    {formData.mobile.length !== 10 && (
                      <p className="text-red-600 text-sm mt-1">Mobile number must be exactly 10 digits</p>
                    )}
                    {formData.mobile.length === 10 && !['6', '7', '8', '9'].includes(formData.mobile[0]) && (
                      <p className="text-red-600 text-sm mt-1">Mobile number must start with 6, 7, 8, or 9</p>
                    )}
                  </>
                )}
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Car Model *
                </label>
                <input
                  type="text"
                  required
                  value={formData.carModel}
                  onChange={(e) => setFormData({ ...formData, carModel: e.target.value })}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#ff8c00] focus:border-transparent text-gray-900 bg-white"
                  placeholder="e.g., Honda City"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Car Number *
                </label>
                <input
                  type="text"
                  required
                  value={formData.carNumber}
                  onChange={(e) => setFormData({ ...formData, carNumber: e.target.value })}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#ff8c00] focus:border-transparent text-gray-900 bg-white"
                  placeholder="e.g., DL01AB1234"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Wash Type *
              </label>
              <div className="space-y-2">
                <label className="flex items-center p-2 sm:p-3 border-2 border-gray-300 rounded-lg cursor-pointer hover:border-[#ff8c00] transition-all">
                  <input
                    type="radio"
                    name="washType"
                    value="external"
                    checked={formData.washType === 'external'}
                    onChange={(e) => setFormData({ ...formData, washType: e.target.value })}
                    className="w-4 h-4 text-[#ff8c00] focus:ring-[#ff8c00]"
                  />
                  <div className="ml-2 sm:ml-3 flex-1">
                    <div className="flex items-center justify-between">
                      <span className="text-sm sm:text-base font-medium text-gray-900">External Wash Only</span>
                      <span className="text-base sm:text-lg font-bold text-[#ff8c00]">₹250</span>
                    </div>
                    <p className="text-xs sm:text-sm text-gray-500 mt-0.5">Exterior cleaning, wheels, and windows</p>
                  </div>
                </label>

                <label className="flex items-center p-2 sm:p-3 border-2 border-gray-300 rounded-lg cursor-pointer hover:border-[#ff8c00] transition-all">
                  <input
                    type="radio"
                    name="washType"
                    value="internal_external"
                    checked={formData.washType === 'internal_external'}
                    onChange={(e) => setFormData({ ...formData, washType: e.target.value })}
                    className="w-4 h-4 text-[#ff8c00] focus:ring-[#ff8c00]"
                  />
                  <div className="ml-2 sm:ml-3 flex-1">
                    <div className="flex items-center justify-between">
                      <span className="text-sm sm:text-base font-medium text-gray-900">Internal + External Cleaning</span>
                      <span className="text-base sm:text-lg font-bold text-[#ff8c00]">₹350</span>
                    </div>
                    <p className="text-xs sm:text-sm text-gray-500 mt-0.5">Complete interior vacuuming, dashboard cleaning, and exterior wash</p>
                  </div>
                </label>
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-2 sm:gap-3">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Booking Date *
                </label>
                <input
                  type="date"
                  required
                  value={formData.bookingDate}
                  onChange={(e) => setFormData({ ...formData, bookingDate: e.target.value })}
                  min={new Date().toISOString().split('T')[0]}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#ff8c00] focus:border-transparent text-gray-900 bg-white"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Preferred Time Slot *
                </label>
                <select
                  required
                  value={formData.preferredTimeSlot}
                  onChange={(e) => setFormData({ ...formData, preferredTimeSlot: e.target.value })}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#ff8c00] focus:border-transparent text-gray-900 bg-white"
                >
                  <option value="">Select time slot</option>
                  <option value="9:00 AM - 11:00 AM">9:00 AM - 11:00 AM</option>
                  <option value="11:00 AM - 1:00 PM">11:00 AM - 1:00 PM</option>
                  <option value="1:00 PM - 3:00 PM">1:00 PM - 3:00 PM</option>
                  <option value="3:00 PM - 5:00 PM">3:00 PM - 5:00 PM</option>
                  <option value="5:00 PM - 7:00 PM">5:00 PM - 7:00 PM</option>
                </select>
              </div>
            </div>

            <div>
              <label className="block text-sm sm:text-base font-semibold text-gray-800 mb-1">
                Location/Address *
              </label>
              <textarea
                required
                value={formData.location}
                onChange={(e) => setFormData({ ...formData, location: e.target.value })}
                rows={2}
                className="w-full px-3 py-2 border-2 border-gray-300 rounded-lg focus:ring-2 focus:ring-[#ff8c00] focus:border-transparent text-sm sm:text-base text-gray-900 bg-white"
                placeholder="Enter your complete address"
              />
            </div>

            <div className="bg-gradient-to-r from-orange-50 to-yellow-50 p-2 sm:p-3 rounded-lg border-2 border-[#ff8c00] shadow-sm">
              <div className="flex items-center justify-between">
                <span className="text-sm sm:text-base font-bold text-gray-900">Total Amount:</span>
                <span className="text-lg sm:text-xl font-extrabold text-[#ff8c00]">₹{price}</span>
              </div>
            </div>

            <div className="flex gap-2 sm:gap-3 pt-2 sm:pt-3">
              <button
                type="button"
                onClick={onClose}
                className="flex-1 px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-all font-semibold"
                disabled={isSubmitting}
              >
                Cancel
              </button>
              <button
                type="submit"
                disabled={isSubmitting}
                className="flex-1 px-6 py-3 bg-[#ff8c00] hover:bg-[#e67e00] text-white rounded-lg transition-all font-semibold disabled:opacity-50"
              >
                {isSubmitting ? 'Booking...' : 'Confirm Booking'}
              </button>
            </div>
          </form>
        )}
      </div>
    </div>
  );
};