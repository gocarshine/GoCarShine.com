import { useState } from 'react';
import { SingleWashBookingModal } from './SingleWashBookingModal';

const Hero = () => {
  const [showOptions, setShowOptions] = useState(false);
  const [showBookingModal, setShowBookingModal] = useState(false);

  return (
    <section id="home" className="relative bg-gradient-to-br from-blue-50 via-white to-blue-50 text-gray-900 pt-24 md:pt-32 pb-12 md:pb-20 min-h-screen flex items-center overflow-hidden">
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_30%_20%,rgba(59,130,246,0.1),transparent_50%),radial-gradient(circle_at_70%_80%,rgba(37,99,235,0.05),transparent_50%)]"></div>
      <div className="relative z-10 w-full mx-auto px-4 md:px-8 lg:px-12 grid md:grid-cols-2 gap-8 md:gap-12 lg:gap-16 items-center">
        <div className="text-center md:text-left">
          <h2 className="text-3xl md:text-4xl lg:text-5xl font-bold leading-tight mb-6 md:mb-8">
            <span className="bg-gradient-to-r from-blue-600 to-blue-700 bg-clip-text text-transparent">GoCarShine</span>
            <br />
            <span className="text-gray-800">Where Your Car's Shine Takes Flight</span>
          </h2>

          <div className="flex flex-wrap gap-4 mb-8 justify-center md:justify-start">
            <div className="bg-white/80 backdrop-blur-md px-4 py-2 rounded-full text-sm border border-blue-200 shadow-md text-blue-700 font-medium">Deep Wash</div>
            <div className="bg-white/80 backdrop-blur-md px-4 py-2 rounded-full text-sm border border-blue-200 shadow-md text-blue-700 font-medium">Deluxe Detailing</div>
            <div className="bg-white/80 backdrop-blur-md px-4 py-2 rounded-full text-sm border border-blue-200 shadow-md text-blue-700 font-medium">Real Time Updates</div>
            <div className="bg-white/80 backdrop-blur-md px-4 py-2 rounded-full text-sm border border-blue-200 shadow-md text-blue-700 font-medium">Premium Care</div>
          </div>

          <h2 className="text-xl sm:text-2xl md:text-3xl lg:text-4xl font-semibold mb-3 md:mb-4 leading-tight text-gray-700">The most convenient car care services at your Door Steps</h2>
          <p className="text-base sm:text-lg md:text-xl font-semibold mb-6 md:mb-8 bg-gradient-to-r from-blue-600 to-blue-700 bg-clip-text text-transparent">with prices starting from just ₹250 per month</p>

          {!showOptions ? (
            <button
              onClick={() => setShowOptions(true)}
              className="bg-gradient-to-r from-blue-600 to-blue-700 text-white px-8 py-4 rounded-full text-lg font-semibold transition-all hover:from-blue-500 hover:to-blue-600 hover:-translate-y-1 shadow-xl hover:shadow-2xl w-full sm:w-auto"
            >
              Book Now
            </button>
          ) : (
            <div className="flex flex-col sm:flex-row gap-4">
              <button
                onClick={() => setShowBookingModal(true)}
                className="bg-gradient-to-r from-emerald-600 to-emerald-700 text-white px-8 py-4 rounded-full text-lg font-semibold transition-all hover:from-emerald-500 hover:to-emerald-600 hover:-translate-y-1 shadow-xl hover:shadow-2xl flex-1 sm:flex-none sm:min-w-[200px]"
              >
                Single Wash
              </button>
              <a
                href="#packages"
                onClick={(e) => {
                  e.preventDefault();
                  const packagesSection = document.getElementById('packages');
                  if (packagesSection) {
                    packagesSection.scrollIntoView({ behavior: 'smooth' });
                    setTimeout(() => {
                      const event = new CustomEvent('showPackageComparison');
                      window.dispatchEvent(event);
                    }, 500);
                  }
                }}
                className="bg-gradient-to-r from-blue-600 to-blue-700 text-white px-8 py-4 rounded-full text-lg font-semibold transition-all hover:from-blue-500 hover:to-blue-600 hover:-translate-y-1 shadow-xl hover:shadow-2xl flex-1 sm:flex-none sm:min-w-[200px] text-center"
              >
                Packages
              </a>
            </div>
          )}
        </div>

        <div className="flex justify-center md:justify-start items-center">
          <img
            src="/files_5734870-1761645261362-Capture7.png"
            alt="Professional car washing service"
            className="rounded-2xl shadow-2xl object-cover w-full h-auto max-w-lg md:max-w-xl lg:max-w-2xl hover:shadow-3xl transition-shadow duration-300 md:mt-0"
          />
        </div>
      </div>

      <SingleWashBookingModal
        isOpen={showBookingModal}
        onClose={() => setShowBookingModal(false)}
      />
    </section>
  );
};

export default Hero;
