import { Check, X, ChevronDown, ChevronUp } from 'lucide-react';
import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

const Packages = () => {
  const navigate = useNavigate();
  const [showComparison, setShowComparison] = useState(false);
  const [selectedCarSize, setSelectedCarSize] = useState<'small' | 'medium' | 'big'>('medium');
  const [showBookingModal, setShowBookingModal] = useState(false);
  const [selectedPackage, setSelectedPackage] = useState<any>(null);
  const [formData, setFormData] = useState({
    customerName: '',
    mobile: '',
    email: '',
    location: 'Gaur Yamuna City',
    address: 'Tower A',
    flatNumber: '',
    preferredTimeSlot: '8:00 AM - 9:00 AM'
  });

  const locationTowerMapping: Record<string, string[]> = {
    'Gaur Yamuna City': [
      'Tower A', 'Tower B', 'Tower C', 'Tower D', 'Tower E', 'Tower F',
      'Tower G', 'Tower H', 'Tower I', 'Tower L', 'Tower K', 'Tower R',
      'Tower S', 'Tower O', 'Tower Q', 'Tower V1 - V6', 'Tower V7 - V12',
      'Tower V13 - V18', 'Tower V19 - V24', '2nd Park View', '3rd Park View',
      '6th Park View', '7th Park View', '32nd Park View', 'Runway Suits'
    ],
    'Eldeco - Rohtak': [
      'Tower A', 'Tower B', 'Tower C', 'Tower D'
    ],
    'Leisure Park - Noida Ext.': [
      'Tower E1', 'Tower E2', 'Tower E3', 'Tower E4',
      'Tower F1', 'Tower F2', 'Tower F3', 'Tower F4',
      'Tower A1', 'Tower A2', 'Tower A3', 'Tower A4', 'Tower A5',
      'Tower B1', 'Tower B2', 'Tower B3', 'Tower B4', 'Tower B5'
    ],
    'Panchsheel Hynish - Noida Ext.': [
      'Tower A', 'Tower B', 'Tower C'
    ]
  };

  const availableTowers = locationTowerMapping[formData.location] || [];

  useEffect(() => {
    const handleShowComparison = () => {
      setShowComparison(true);
    };

    window.addEventListener('showPackageComparison', handleShowComparison);

    return () => {
      window.removeEventListener('showPackageComparison', handleShowComparison);
    };
  }, []);

  const monthlyPricing = {
    small: 800,
    medium: 900,
    big: 1000
  };

  const quarterlyPricing = {
    small: 2200,
    medium: 2500,
    big: 2700
  };

  const yearlyPricing = {
    small: 8600,
    medium: 9900,
    big: 10500
  };

  const getPackagePrice = (packagePeriod: string, carSize: 'small' | 'medium' | 'big') => {
    if (packagePeriod === 'per month') {
      return monthlyPricing[carSize];
    } else if (packagePeriod === 'per quarter') {
      return quarterlyPricing[carSize];
    } else if (packagePeriod === 'per year') {
      return yearlyPricing[carSize];
    }
    return 0;
  };

  const packages = [
    {
      name: 'Monthly Sparkle Package',
      price: monthlyPricing[selectedCarSize],
      period: 'per month',
      features: [
        'Daily Cleaning (Exterior)',
        'Interior cleaning (Weekly)',
        'Full wash Exterior (Once in a Month)',
        'Odor Elimination (Monthly)',
        'Tire Dressing/Shine',
        'Dashboard and Console Polishing/Conditioning',
        'AC Vent Cleaning'
      ],
      featured: false,
      hasCarSizeOptions: true
    },
    {
      name: 'Quarterly Shine Package',
      price: quarterlyPricing[selectedCarSize],
      period: 'per quarter',
      features: [
        'Daily exterior car wash',
        'Interior cleaning twice a month',
        'One full-service wash every month',
        'Rubbing and Polishing (Half Yearly)',
        'Odor Elimination (Monthly)',
        'Waxing (Quarterly)',
        'Tire Dressing/Shine',
        'Dashboard and Console Polishing/Conditioning',
        'AC Vent Cleaning'
      ],
      featured: true,
      hasCarSizeOptions: true
    },
    {
      name: 'Yearly Prestige Package',
      price: yearlyPricing[selectedCarSize],
      period: 'per year',
      features: [
        'Daily exterior car wash',
        'Interior cleaning twice a month',
        'One full-service wash every month',
        'Rubbing and Polishing (Half Yearly)',
        'Odor Elimination (Monthly)',
        'Antiviral & Bacterial Treatment/Sanitization',
        'Tire Dressing/Shine',
        'Interior Vacuuming',
        'Upholstery/Carpet Shampooing (Half Yearly)',
        'Dashboard and Console Polishing/Conditioning',
        'AC Vent Cleaning',
        'Flat tyre assistance'
      ],
      featured: false,
      hasCarSizeOptions: true
    }
  ];

  const comparisonFeatures = [
    { name: 'Rubbing and Polishing (Half Yearly)', sparkle: false, shine: true, prestige: true },
    { name: 'Odor Elimination (Monthly)', sparkle: true, shine: true, prestige: true },
    { name: 'Antiviral & Bacterial Treatment/Sanitization', sparkle: false, shine: false, prestige: true },
    { name: 'Waxing (Quarterly)', sparkle: false, shine: true, prestige: true },
    { name: 'Tire Dressing/Shine', sparkle: true, shine: true, prestige: true },
    { name: 'Interior Vacuuming', sparkle: false, shine: false, prestige: true },
    { name: 'Ceramic Coating (Yearly)', sparkle: false, shine: false, prestige: true },
    { name: 'Upholstery/Carpet Shampooing (Half Yearly)', sparkle: false, shine: false, prestige: true },
    { name: 'Dashboard and Console Polishing/Conditioning', sparkle: true, shine: true, prestige: true },
    { name: 'AC Vent Cleaning', sparkle: true, shine: true, prestige: true }
  ];

  return (
    <section id="packages" className="relative py-20 bg-white scroll-mt-20">
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_70%_30%,rgba(59,130,246,0.05),transparent_60%)]"></div>
      <div className="relative z-10 max-w-[1400px] mx-auto px-8 lg:px-12">
        <h2 className="text-center text-3xl md:text-4xl font-bold mb-4 text-gray-800 px-4">Choose Your Package</h2>
        <p className="text-center text-xl text-gray-600 mb-16 max-w-[800px] mx-auto">
          Choose the perfect plan for your car's needs — from regular cleaning to premium detailing and full-year maintenance, we've got you covered.
        </p>
        <div className="grid md:grid-cols-3 gap-6 lg:gap-8">
          {packages.map((pkg, index) => (
            <div
              key={index}
              className={`bg-white rounded-3xl p-6 lg:p-8 shadow-lg transition-all hover:-translate-y-3 hover:shadow-2xl relative border-2 w-full ${
                pkg.featured ? 'border-blue-500 scale-105 md:scale-110 shadow-blue-200' : 'border-gray-200'
              }`}
            >
              {pkg.featured && (
                <div className="absolute -top-4 left-1/2 -translate-x-1/2 bg-gradient-to-r from-blue-600 to-blue-700 text-white px-6 py-2 rounded-full text-sm font-semibold shadow-lg">
                  Recommended
                </div>
              )}

              <div className="text-center mb-8">
                <h3 className="text-3xl font-bold mb-4 text-gray-800">{pkg.name}</h3>

                {pkg.hasCarSizeOptions && (
                  <div className="mb-6">
                    <p className="text-sm text-gray-600 mb-3">Select Car Size:</p>
                    <div className="flex gap-2 justify-center">
                      <button
                        onClick={() => setSelectedCarSize('small')}
                        className={`px-4 py-2 rounded-lg text-sm font-semibold transition-all ${
                          selectedCarSize === 'small'
                            ? 'bg-gradient-to-r from-blue-600 to-blue-700 text-white shadow-lg'
                            : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                        }`}
                      >
                        Small
                      </button>
                      <button
                        onClick={() => setSelectedCarSize('medium')}
                        className={`px-4 py-2 rounded-lg text-sm font-semibold transition-all ${
                          selectedCarSize === 'medium'
                            ? 'bg-gradient-to-r from-blue-600 to-blue-700 text-white shadow-lg'
                            : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                        }`}
                      >
                        Medium
                      </button>
                      <button
                        onClick={() => setSelectedCarSize('big')}
                        className={`px-4 py-2 rounded-lg text-sm font-semibold transition-all ${
                          selectedCarSize === 'big'
                            ? 'bg-gradient-to-r from-blue-600 to-blue-700 text-white shadow-lg'
                            : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                        }`}
                      >
                        Big
                      </button>
                    </div>
                  </div>
                )}

                <div className="flex items-baseline justify-center mb-4">
                  <span className="text-2xl text-gray-600 mr-1">₹</span>
                  <span className="text-5xl font-black bg-gradient-to-r from-blue-600 to-blue-700 bg-clip-text text-transparent leading-none">{pkg.price}</span>
                  <span className="text-base text-gray-600 ml-2">{pkg.period}</span>
                </div>
              </div>

              <ul className="mb-8">
                {pkg.features.map((feature, i) => (
                  <li key={i} className="flex items-center mb-3 text-base text-gray-700">
                    <Check className="w-5 h-5 text-emerald-500 mr-3 flex-shrink-0" />
                    {feature}
                  </li>
                ))}
              </ul>

              <button
                onClick={() => {
                  setSelectedPackage(pkg);
                  setShowBookingModal(true);
                }}
                className={`w-full px-8 py-4 rounded-full text-lg font-semibold transition-all hover:-translate-y-1 shadow-lg hover:shadow-xl ${
                pkg.featured
                  ? 'bg-gradient-to-r from-blue-600 to-blue-700 text-white hover:from-blue-500 hover:to-blue-600'
                  : 'bg-gradient-to-r from-gray-700 to-gray-800 text-white hover:from-gray-600 hover:to-gray-700'
              }`}>
                Select This Plan
              </button>
            </div>
          ))}
        </div>

        <div className="mt-16 text-center">
          <button
            onClick={() => setShowComparison(!showComparison)}
            className="bg-gradient-to-r from-blue-600 to-blue-700 text-white px-8 py-4 rounded-full text-lg font-semibold transition-all hover:from-blue-500 hover:to-blue-600 hover:-translate-y-1 shadow-lg hover:shadow-xl inline-flex items-center gap-2"
          >
            {showComparison ? 'Hide' : 'Show'} Detailed Comparison
            {showComparison ? <ChevronUp className="w-5 h-5" /> : <ChevronDown className="w-5 h-5" />}
          </button>
        </div>

        {showComparison && (
          <div className="mt-12 bg-white rounded-3xl p-8 shadow-lg border border-gray-200 overflow-x-auto">
            <h3 className="text-2xl font-bold mb-6 text-gray-800 text-center">Package Features Comparison</h3>
            <table className="w-full border-collapse">
              <thead>
                <tr className="border-b-2 border-gray-200">
                  <th className="text-left py-4 px-4 text-gray-800 font-semibold">Feature</th>
                  <th className="text-center py-4 px-4 text-gray-800 font-semibold">Monthly Sparkle</th>
                  <th className="text-center py-4 px-4 text-gray-800 font-semibold">Quarterly Shine</th>
                  <th className="text-center py-4 px-4 text-gray-800 font-semibold">Yearly Prestige</th>
                </tr>
              </thead>
              <tbody>
                {comparisonFeatures.map((feature, index) => (
                  <tr key={index} className="border-b border-gray-100 hover:bg-gray-50 transition-colors">
                    <td className="py-4 px-4 text-gray-700">{feature.name}</td>
                    <td className="py-4 px-4 text-center">
                      {feature.sparkle ? (
                        <Check className="w-6 h-6 text-emerald-500 mx-auto" />
                      ) : (
                        <X className="w-6 h-6 text-red-500 mx-auto" />
                      )}
                    </td>
                    <td className="py-4 px-4 text-center">
                      {feature.shine ? (
                        <Check className="w-6 h-6 text-emerald-500 mx-auto" />
                      ) : (
                        <X className="w-6 h-6 text-red-500 mx-auto" />
                      )}
                    </td>
                    <td className="py-4 px-4 text-center">
                      {feature.prestige ? (
                        <Check className="w-6 h-6 text-emerald-500 mx-auto" />
                      ) : (
                        <X className="w-6 h-6 text-red-500 mx-auto" />
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}

        {showBookingModal && (
          <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-2 sm:p-4 overflow-y-auto">
            <div className="bg-white rounded-2xl sm:rounded-3xl p-4 sm:p-6 md:p-8 max-w-md w-full shadow-2xl border border-gray-200 relative my-4">
              <button
                onClick={() => {
                  setShowBookingModal(false);
                  const defaultLocation = 'Gaur Yamuna City';
                  const defaultTower = locationTowerMapping[defaultLocation][0];
                  setFormData({ customerName: '', mobile: '', email: '', location: defaultLocation, address: defaultTower, flatNumber: '', preferredTimeSlot: '8:00 AM - 9:00 AM' });
                }}
                className="absolute top-3 right-3 sm:top-4 sm:right-4 text-gray-400 hover:text-gray-600 transition-colors z-10"
              >
                <X className="w-5 h-5 sm:w-6 sm:h-6" />
              </button>

              <h3 className="text-xl font-bold text-gray-800 mb-4 pr-8 mt-6">Step 1: Contact Information</h3>

              <form onSubmit={(e) => {
                e.preventDefault();
                const calculatedPrice = getPackagePrice(selectedPackage.period, selectedCarSize);
                navigate('/car-details', {
                  state: {
                    bookingData: {
                      customer_name: formData.customerName,
                      package_name: selectedPackage.name,
                      package_price: calculatedPrice,
                      package_period: selectedPackage.period,
                      car_size: selectedCarSize,
                      contact_no: formData.mobile,
                      email: formData.email,
                      location: formData.location,
                      address: `${formData.address}, Flat ${formData.flatNumber}`,
                      preferred_time_slot: formData.preferredTimeSlot
                    }
                  }
                });
              }}>
                <div className="space-y-2.5">
                  <div>
                    <label className="block text-gray-700 mb-1 font-medium text-sm">Customer Name *</label>
                    <input
                      type="text"
                      required
                      value={formData.customerName}
                      onChange={(e) => setFormData({ ...formData, customerName: e.target.value })}
                      placeholder="Enter your full name"
                      className="w-full px-3 py-2 bg-white text-gray-800 text-sm rounded-lg border border-gray-300 focus:border-blue-500 focus:outline-none transition-colors"
                    />
                  </div>

                  <div>
                    <label className="block text-gray-700 mb-1 font-medium text-sm">Contact No. *</label>
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
                      placeholder="Enter 10-digit mobile number"
                      className="w-full px-3 py-2 bg-white text-gray-800 text-sm rounded-lg border border-gray-300 focus:border-blue-500 focus:outline-none transition-colors"
                    />
                    {formData.mobile && formData.mobile.length > 0 && (
                      <>
                        {formData.mobile.length !== 10 && (
                          <p className="text-red-400 text-xs mt-1">Mobile number must be exactly 10 digits</p>
                        )}
                        {formData.mobile.length === 10 && !['6', '7', '8', '9'].includes(formData.mobile[0]) && (
                          <p className="text-red-400 text-xs mt-1">Mobile number must start with 6, 7, 8, or 9</p>
                        )}
                      </>
                    )}
                  </div>

                  <div>
                    <label className="block text-gray-700 mb-1 font-medium text-sm">Email Address *</label>
                    <input
                      type="email"
                      required
                      value={formData.email}
                      onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                      placeholder="Enter your email"
                      className="w-full px-3 py-2 bg-white text-gray-800 text-sm rounded-lg border border-gray-300 focus:border-blue-500 focus:outline-none transition-colors"
                    />
                  </div>

                  <div>
                    <label className="block text-gray-700 mb-1 font-medium text-sm">Location *</label>
                    <select
                      required
                      value={formData.location}
                      onChange={(e) => {
                        const newLocation = e.target.value;
                        const newTowers = locationTowerMapping[newLocation] || [];
                        setFormData({
                          ...formData,
                          location: newLocation,
                          address: newTowers[0] || ''
                        });
                      }}
                      className="w-full px-3 py-2 bg-white text-gray-800 text-sm rounded-lg border border-gray-300 focus:border-blue-500 focus:outline-none transition-colors"
                    >
                      <option value="Gaur Yamuna City">Gaur Yamuna City</option>
                      <option value="Eldeco - Rohtak">Eldeco - Rohtak </option>
                      <option value="Leisure Park - Noida Ext.">Leisure Park - Noida Ext.</option>
                      <option value="Panchsheel Hynish - Noida Ext.">Panchsheel Hynish - Noida Ext.</option>
                    </select>
                  </div>

                  <div className="grid grid-cols-2 gap-2.5">
                    <div>
                      <label className="block text-gray-700 mb-1 font-medium text-sm">Tower *</label>
                      <select
                        required
                        value={formData.address}
                        onChange={(e) => setFormData({ ...formData, address: e.target.value })}
                        className="w-full px-2.5 py-2 bg-white text-gray-800 text-sm rounded-lg border border-gray-300 focus:border-blue-500 focus:outline-none transition-colors"
                      >
                        {availableTowers.map((tower) => (
                          <option key={tower} value={tower}>{tower}</option>
                        ))}
                      </select>
                    </div>
                    <div>
                      <label className="block text-gray-700 mb-1 font-medium text-sm">Flat No. / Villa No.*</label>
                      <input
                        type="text"
                        required
                        value={formData.flatNumber}
                        onChange={(e) => setFormData({ ...formData, flatNumber: e.target.value })}
                        placeholder="e.g., 101 and V1-102345"
                        className="w-full px-2.5 py-2 bg-white text-gray-800 text-sm rounded-lg border border-gray-300 focus:border-blue-500 focus:outline-none transition-colors"
                      />
                    </div>
                  </div>

                  <div>
                    <label className="block text-gray-700 mb-1 font-medium text-sm">Preferred Time Slot *</label>
                    <select
                      required
                      value={formData.preferredTimeSlot}
                      onChange={(e) => setFormData({ ...formData, preferredTimeSlot: e.target.value })}
                      className="w-full px-3 py-2 bg-white text-gray-800 text-sm rounded-lg border border-gray-300 focus:border-blue-500 focus:outline-none transition-colors"
                    >
                      <option value="5:00 AM - 6:00 AM">5:00 AM - 6:00 AM</option>
                      <option value="6:00 AM - 7:00 AM">6:00 AM - 7:00 AM</option>
                      <option value="7:00 AM - 8:00 AM">7:00 AM - 8:00 AM</option>
                      <option value="8:00 AM - 9:00 AM">8:00 AM - 9:00 AM</option>
                      <option value="9:00 AM - 10:00 AM">9:00 AM - 10:00 AM</option>
                      <option value="10:00 AM - 11:00 AM">10:00 AM - 11:00 AM</option>
                      <option value="11:00 AM - 12:00 PM">11:00 AM - 12:00 PM</option>
                    </select>
                    <p className="text-gray-500 text-xs mt-1">Select your preferred service time</p>
                  </div>

                  <div className="flex gap-2.5 pt-3">
                    <button
                      type="button"
                      onClick={() => {
                        setShowBookingModal(false);
                        const defaultLocation = 'Gaur Yamuna City';
                        const defaultTower = locationTowerMapping[defaultLocation][0];
                        setFormData({ customerName: '', mobile: '', email: '', location: defaultLocation, address: defaultTower, flatNumber: '', preferredTimeSlot: '8:00 AM - 9:00 AM' });
                      }}
                      className="flex-1 px-4 py-2.5 bg-gray-200 text-gray-700 rounded-full text-sm font-semibold transition-all hover:bg-gray-300 shadow-md"
                    >
                      Cancel
                    </button>
                    <button
                      type="submit"
                      className="flex-1 px-4 py-2.5 bg-gradient-to-r from-blue-600 to-blue-700 text-white rounded-full text-sm font-semibold transition-all hover:from-blue-500 hover:to-blue-600 hover:-translate-y-1 shadow-lg hover:shadow-xl"
                    >
                      Next: Car Details
                    </button>
                  </div>
                </div>
              </form>
            </div>
          </div>
        )}
      </div>
    </section>
  );
};

export default Packages;
