import { Sparkles, Shield, Clock, Award } from 'lucide-react';

const WhatWeOffer = () => {
  const offerings = [
    {
      icon: Sparkles,
      title: 'Premium Cleaning',
      description: 'Professional car wash and detailing services using eco-friendly products for a spotless finish.'
    },
    {
      icon: Shield,
      title: 'Protected Care',
      description: 'Advanced protective treatments including waxing, ceramic coating, and paint protection.'
    },
    {
      icon: Clock,
      title: 'Flexible Scheduling',
      description: 'Book services at your convenience with daily, weekly, or monthly maintenance packages.'
    },
    {
      icon: Award,
      title: 'Quality Guarantee',
      description: 'Experienced professionals dedicated to delivering exceptional results every time.'
    }
  ];

  const detailedServices = [
    {
      title: 'Interior Vacuuming',
      description: 'Thorough vacuuming of the cabin, seats, carpets, and boot to remove loose dirt and debris.'
    },
    {
      title: 'Upholstery/Carpet Shampooing',
      description: 'Deep cleaning using a foam or wet shampoo process to remove tough stains, dirt, and odors from fabric or carpeted surfaces.'
    },
    {
      title: 'Leather Conditioning',
      description: 'Specialized cleaning and conditioning treatments are applied to leather seats and surfaces to maintain their quality and prevent cracking.'
    },
    {
      title: 'Dashboard and Console Polishing/Conditioning',
      description: 'Interior plastic and vinyl surfaces are cleaned and dressed to restore their look and protect them from sun damage.'
    },
    {
      title: 'AC Vent Cleaning',
      description: 'Cleaning of the air conditioning vents to remove dust and allergens, often with an anti-microbial treatment for a hygienic cabin environment.'
    },
    {
      title: 'Odor Elimination',
      description: 'Treatments aimed at removing unpleasant smells and leaving a fresh scent in the cabin.'
    },
    {
      title: 'Antiviral & Bacterial Treatment/Sanitization',
      description: 'Use of steam or specific chemicals to kill germs and bacteria within the interior for a healthier environment.'
    },
    {
      title: 'Engine Bay Cleaning',
      description: 'The engine compartment is degreased and pressure washed to remove built-up dirt and oil, followed by the application of protective dressings to plastic and rubber components.'
    }
  ];

  return (
    <section className="relative py-20 bg-gradient-to-b from-gray-50 to-white">
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_50%_50%,rgba(59,130,246,0.03),transparent_70%)]"></div>
      <div className="relative z-10 max-w-[1400px] mx-auto px-5">
        <div className="text-center mb-16">
          <h2 className="text-4xl md:text-5xl font-bold text-gray-800 mb-4">
            What We <span className="bg-gradient-to-r from-blue-600 to-blue-700 bg-clip-text text-transparent">Offer</span>
          </h2>
          <p className="text-xl text-black-300 max-w-2xl mx-auto">
            Comprehensive car care solutions tailored to keep your vehicle looking pristine and performing at its best.
          </p>
        </div>

        <div className="grid lg:grid-cols-2 gap-12 items-start">
          <div>
            <div className="grid sm:grid-cols-2 gap-6 mb-8">
              {offerings.map((offer, index) => {
                const Icon = offer.icon;
                return (
                  <div
                    key={index}
                    className="bg-white rounded-2xl p-6 border-2 border-gray-200 hover:border-blue-500 transition-all duration-300 hover:-translate-y-2 hover:shadow-xl group"
                  >
                    <div className="bg-gradient-to-br from-blue-600 to-blue-700 w-14 h-14 rounded-2xl flex items-center justify-center mb-4 group-hover:scale-110 transition-transform duration-300 shadow-lg">
                      <Icon className="w-7 h-7 text-white" />
                    </div>
                    <h3 className="text-lg font-bold text-gray-800 mb-2">{offer.title}</h3>
                    <p className="text-gray-600 text-sm leading-relaxed">{offer.description}</p>
                  </div>
                );
              })}
            </div>

            <div className="bg-white rounded-2xl p-8 border-2 border-gray-200">
              <h3 className="text-2xl font-bold text-gray-800 mb-6 text-center">
                Detailed <span className="bg-gradient-to-r from-blue-600 to-blue-700 bg-clip-text text-transparent">Services</span>
              </h3>
              <div className="space-y-6 max-h-[400px] overflow-y-auto pr-2 custom-scrollbar">
                {detailedServices.map((service, index) => (
                  <div key={index} className="pb-6 border-b border-gray-200 last:border-b-0">
                    <h4 className="text-lg font-semibold bg-gradient-to-r from-blue-600 to-blue-700 bg-clip-text text-transparent mb-2">{service.title}</h4>
                    <p className="text-gray-600 text-sm leading-relaxed">{service.description}</p>
                  </div>
                ))}
              </div>
              <p className="text-gray-500 text-sm mt-6 text-center italic">
                These services are typically offered in different packages, allowing customers to choose the level of cleaning and protection that best suits their needs and budget.
              </p>
            </div>
          </div>

          <div className="flex flex-col gap-6">
            <img
              src="/Complete.PNG"
              alt="Complete Car Care Services"
              className="rounded-2xl shadow-2xl max-w-full h-auto"
            />
            <img
              src="/Copilot_20251127_144547.png"
              alt="Professional Car Wash Service"
              className="rounded-2xl shadow-2xl max-w-full h-auto"
            />
          </div>
        </div>
      </div>
    </section>
  );
};

export default WhatWeOffer;
