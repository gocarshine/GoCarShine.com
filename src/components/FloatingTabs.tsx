import { useState } from 'react';
import { useLocation } from 'react-router-dom';
import { MessageSquare, Phone, MessageCircle, X, Star } from 'lucide-react';
import { supabase } from '../lib/supabase';

const FloatingTabs = () => {
  const location = useLocation();
  const [showEnquiryForm, setShowEnquiryForm] = useState(false);
  const [showCallPopup, setShowCallPopup] = useState(false);
  const [showFeedbackForm, setShowFeedbackForm] = useState(false);
  const [formData, setFormData] = useState({
    name: '',
    mobile: '',
    message: ''
  });
  const [feedbackData, setFeedbackData] = useState({
    name: '',
    mobile: '',
    rating: 5,
    feedback: ''
  });
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitSuccess, setSubmitSuccess] = useState(false);
  const [feedbackSubmitting, setFeedbackSubmitting] = useState(false);
  const [feedbackSuccess, setFeedbackSuccess] = useState(false);

  const phoneNumber = '+917505412272';
  const isAdminPage = location.pathname.startsWith('/admin');

  const handleEnquirySubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);

    try {
      const { error } = await supabase
        .from('enquiries')
        .insert([{
          name: formData.name,
          mobile: formData.mobile,
          message: formData.message
        }]);

      if (error) throw error;

      const apiUrl = `${import.meta.env.VITE_SUPABASE_URL}/functions/v1/send-email`;
      await fetch(apiUrl, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${import.meta.env.VITE_SUPABASE_ANON_KEY}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          type: 'enquiry',
          name: formData.name,
          mobile: formData.mobile,
          message: formData.message
        })
      });

      setSubmitSuccess(true);
      setFormData({ name: '', mobile: '', message: '' });

      setTimeout(() => {
        setShowEnquiryForm(false);
        setSubmitSuccess(false);
      }, 2000);
    } catch (error: any) {
      alert('Failed to submit enquiry. Please try again.');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleCallClick = () => {
    if (window.innerWidth <= 768) {
      window.location.href = `tel:${phoneNumber}`;
    } else {
      setShowCallPopup(true);
    }
  };

  const handleWhatsAppClick = () => {
    window.open(`https://wa.me/${phoneNumber.replace('+', '')}`, '_blank');
  };

  const handleFeedbackSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setFeedbackSubmitting(true);

    try {
      const { error } = await supabase
        .from('enquiries')
        .insert([{
          name: feedbackData.name,
          mobile: feedbackData.mobile,
          message: `Rating: ${feedbackData.rating}/5 - ${feedbackData.feedback}`
        }]);

      if (error) throw error;

      const apiUrl = `${import.meta.env.VITE_SUPABASE_URL}/functions/v1/send-email`;
      await fetch(apiUrl, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${import.meta.env.VITE_SUPABASE_ANON_KEY}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          type: 'feedback',
          name: feedbackData.name,
          mobile: feedbackData.mobile,
          rating: feedbackData.rating,
          feedback: feedbackData.feedback
        })
      });

      setFeedbackSuccess(true);
      setFeedbackData({ name: '', mobile: '', rating: 5, feedback: '' });

      setTimeout(() => {
        setShowFeedbackForm(false);
        setFeedbackSuccess(false);
      }, 2000);
    } catch (error: any) {
      alert('Failed to submit feedback. Please try again.');
    } finally {
      setFeedbackSubmitting(false);
    }
  };

  if (isAdminPage) {
    return null;
  }

  return (
    <>
      <div className="fixed right-0 top-1/2 -translate-y-1/2 z-40 flex flex-col gap-2">
        <button
          onClick={() => setShowEnquiryForm(true)}
          className="bg-[#ff8c00] hover:bg-[#e67e00] text-white px-3 py-3 rounded-l-lg shadow-lg transition-all hover:pr-4 group flex items-center gap-2"
          title="Enquiry"
        >
          <MessageSquare className="w-5 h-5" />
        </button>

        <button
          onClick={handleCallClick}
          className="bg-blue-600 hover:bg-blue-700 text-white px-3 py-3 rounded-l-lg shadow-lg transition-all hover:pr-4 group flex items-center gap-2"
          title="Call Us"
        >
          <Phone className="w-5 h-5" />
        </button>

        <button
          onClick={handleWhatsAppClick}
          className="bg-green-600 hover:bg-green-700 text-white px-3 py-3 rounded-l-lg shadow-lg transition-all hover:pr-4 group flex items-center gap-2"
          title="WhatsApp"
        >
          <MessageCircle className="w-5 h-5" />
        </button>

        <button
          onClick={() => setShowFeedbackForm(true)}
          className="bg-purple-600 hover:bg-purple-700 text-white px-3 py-3 rounded-l-lg shadow-lg transition-all hover:pr-4 group flex items-center gap-2"
          title="Feedback"
        >
          <Star className="w-5 h-5" />
        </button>
      </div>

      {showEnquiryForm && (
        <div className="fixed right-0 top-1/2 -translate-y-1/2 mr-12 z-50 animate-slide-in">
          <div className="bg-white rounded-lg shadow-2xl max-w-xs w-80 p-4 relative">
            <button
              onClick={() => setShowEnquiryForm(false)}
              className="absolute top-2 right-2 text-gray-500 hover:text-gray-700 transition-colors"
            >
              <X className="w-5 h-5" />
            </button>

            <h2 className="text-lg font-bold text-gray-800 mb-4">Send Enquiry</h2>

            {submitSuccess ? (
              <div className="text-center py-4">
                <div className="w-12 h-12 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-3">
                  <svg className="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                  </svg>
                </div>
                <p className="text-green-600 font-semibold">Enquiry submitted!</p>
              </div>
            ) : (
              <form onSubmit={handleEnquirySubmit} className="space-y-3">
                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1">Name</label>
                  <input
                    type="text"
                    value={formData.name}
                    onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                    className="w-full px-3 py-1.5 text-sm border-2 border-gray-300 rounded-lg focus:outline-none focus:border-[#ff8c00] transition-colors text-gray-800"
                    required
                  />
                </div>

                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1">Mobile Number</label>
                  <input
                    type="tel"
                    value={formData.mobile}
                    onChange={(e) => {
                      const value = e.target.value.replace(/\D/g, '');
                      if (value.length <= 10) {
                        setFormData({ ...formData, mobile: value });
                      }
                    }}
                    pattern="[6-9][0-9]{9}"
                    maxLength={10}
                    className="w-full px-3 py-1.5 text-sm border-2 border-gray-300 rounded-lg focus:outline-none focus:border-[#ff8c00] transition-colors text-gray-800"
                    placeholder="Enter 10-digit mobile number"
                    required
                  />
                  {formData.mobile && formData.mobile.length > 0 && (
                    <>
                      {formData.mobile.length !== 10 && (
                        <p className="text-red-600 text-xs mt-1">Mobile number must be exactly 10 digits</p>
                      )}
                      {formData.mobile.length === 10 && !['6', '7', '8', '9'].includes(formData.mobile[0]) && (
                        <p className="text-red-600 text-xs mt-1">Mobile number must start with 6, 7, 8, or 9</p>
                      )}
                    </>
                  )}
                </div>

                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1">Message</label>
                  <textarea
                    value={formData.message}
                    onChange={(e) => setFormData({ ...formData, message: e.target.value })}
                    rows={3}
                    className="w-full px-3 py-1.5 text-sm border-2 border-gray-300 rounded-lg focus:outline-none focus:border-[#ff8c00] transition-colors resize-none text-gray-800"
                    required
                  />
                </div>

                <button
                  type="submit"
                  disabled={isSubmitting}
                  className="w-full bg-[#ff8c00] hover:bg-[#e67e00] disabled:opacity-50 text-white py-2 rounded-lg font-semibold transition-all text-sm"
                >
                  {isSubmitting ? 'Submitting...' : 'Submit'}
                </button>
              </form>
            )}
          </div>
        </div>
      )}

      {showCallPopup && (
        <div className="fixed right-0 top-1/2 -translate-y-1/2 mr-12 z-50 animate-slide-in">
          <div className="bg-white rounded-lg shadow-2xl max-w-xs w-64 p-4 relative">
            <button
              onClick={() => setShowCallPopup(false)}
              className="absolute top-2 right-2 text-gray-500 hover:text-gray-700 transition-colors"
            >
              <X className="w-5 h-5" />
            </button>

            <div className="text-center pt-2">
              <div className="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-3">
                <Phone className="w-6 h-6 text-blue-600" />
              </div>
              <h2 className="text-lg font-bold text-gray-800 mb-2">Call Us</h2>
              <p className="text-xl font-bold text-[#ff8c00] mb-4">{phoneNumber}</p>
              <a
                href={`tel:${phoneNumber}`}
                className="block w-full bg-blue-600 hover:bg-blue-700 text-white py-2 rounded-lg font-semibold transition-all"
              >
                Click to Call
              </a>
            </div>
          </div>
        </div>
      )}

      {showFeedbackForm && (
        <div className="fixed right-0 top-1/2 -translate-y-1/2 mr-12 z-50 animate-slide-in">
          <div className="bg-white rounded-lg shadow-2xl max-w-xs w-80 p-4 relative">
            <button
              onClick={() => setShowFeedbackForm(false)}
              className="absolute top-2 right-2 text-gray-500 hover:text-gray-700 transition-colors"
            >
              <X className="w-5 h-5" />
            </button>

            <h2 className="text-lg font-bold text-gray-800 mb-4">Feedback</h2>

            {feedbackSuccess ? (
              <div className="text-center py-4">
                <div className="w-12 h-12 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-3">
                  <svg className="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                  </svg>
                </div>
                <p className="text-green-600 font-semibold">Feedback submitted!</p>
              </div>
            ) : (
              <form onSubmit={handleFeedbackSubmit} className="space-y-3">
                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1">Name</label>
                  <input
                    type="text"
                    value={feedbackData.name}
                    onChange={(e) => setFeedbackData({ ...feedbackData, name: e.target.value })}
                    className="w-full px-3 py-1.5 text-sm border-2 border-gray-300 rounded-lg focus:outline-none focus:border-purple-600 transition-colors text-gray-800"
                    required
                  />
                </div>

                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1">Mobile Number</label>
                  <input
                    type="tel"
                    value={feedbackData.mobile}
                    onChange={(e) => {
                      const value = e.target.value.replace(/\D/g, '');
                      if (value.length <= 10) {
                        setFeedbackData({ ...feedbackData, mobile: value });
                      }
                    }}
                    pattern="[6-9][0-9]{9}"
                    maxLength={10}
                    className="w-full px-3 py-1.5 text-sm border-2 border-gray-300 rounded-lg focus:outline-none focus:border-purple-600 transition-colors text-gray-800"
                    placeholder="Enter 10-digit mobile number"
                    required
                  />
                  {feedbackData.mobile && feedbackData.mobile.length > 0 && (
                    <>
                      {feedbackData.mobile.length !== 10 && (
                        <p className="text-red-600 text-xs mt-1">Mobile number must be exactly 10 digits</p>
                      )}
                      {feedbackData.mobile.length === 10 && !['6', '7', '8', '9'].includes(feedbackData.mobile[0]) && (
                        <p className="text-red-600 text-xs mt-1">Mobile number must start with 6, 7, 8, or 9</p>
                      )}
                    </>
                  )}
                </div>

                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1">Rating</label>
                  <div className="flex gap-1 justify-center mb-2">
                    {[1, 2, 3, 4, 5].map((star) => (
                      <button
                        key={star}
                        type="button"
                        onClick={() => setFeedbackData({ ...feedbackData, rating: star })}
                        className="focus:outline-none"
                      >
                        <Star
                          className={`w-6 h-6 ${
                            star <= feedbackData.rating
                              ? 'fill-yellow-400 text-yellow-400'
                              : 'text-gray-300'
                          }`}
                        />
                      </button>
                    ))}
                  </div>
                </div>

                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1">Feedback</label>
                  <textarea
                    value={feedbackData.feedback}
                    onChange={(e) => setFeedbackData({ ...feedbackData, feedback: e.target.value })}
                    rows={3}
                    className="w-full px-3 py-1.5 text-sm border-2 border-gray-300 rounded-lg focus:outline-none focus:border-purple-600 transition-colors resize-none text-gray-800"
                    required
                  />
                </div>

                <button
                  type="submit"
                  disabled={feedbackSubmitting}
                  className="w-full bg-purple-600 hover:bg-purple-700 disabled:opacity-50 text-white py-2 rounded-lg font-semibold transition-all text-sm"
                >
                  {feedbackSubmitting ? 'Submitting...' : 'Submit'}
                </button>
              </form>
            )}
          </div>
        </div>
      )}

      <style>{`
        @keyframes scale-in {
          from {
            opacity: 0;
            transform: scale(0.9);
          }
          to {
            opacity: 1;
            transform: scale(1);
          }
        }
        .animate-scale-in {
          animation: scale-in 0.2s ease-out;
        }
        @keyframes slide-in {
          from {
            opacity: 0;
            transform: translateY(-50%) translateX(20px);
          }
          to {
            opacity: 1;
            transform: translateY(-50%) translateX(0);
          }
        }
        .animate-slide-in {
          animation: slide-in 0.3s ease-out;
        }
      `}</style>
    </>
  );
};

export default FloatingTabs;
