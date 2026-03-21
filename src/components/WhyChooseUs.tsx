import { useState } from 'react';
import { MessageCircle, Shield, DollarSign, Headphones } from 'lucide-react';

const WhyChooseUs = () => {
  const [activeTab, setActiveTab] = useState('consultation');

  const tabs = [
    {
      id: 'consultation',
      icon: MessageCircle,
      label: 'Free Consultation',
      title: 'Free Consultation',
      subtitle: 'Shine. Advice. Plan.',
      description: 'Get expert advice on the best cleaning and detailing services for your car. Our professionals will assess your vehicle and recommend the perfect care plan tailored to your needs and budget.'
    },
    {
      id: 'promise',
      icon: Shield,
      label: 'Spotless Promise',
      title: 'Spotless Promise',
      subtitle: 'Pure. Bright. Assured.',
      description: 'We guarantee spotless results every time. Our meticulous attention to detail ensures your car looks, feels, and smells brand new after every service.'
    },
    {
      id: 'value',
      icon: DollarSign,
      label: 'Value for money',
      title: 'Value for money',
      subtitle: 'Fair. Honest. Value.',
      description: 'Premium car care at competitive prices. Our transparent pricing and value-for-money packages ensure you get the best service without breaking the bank.'
    },
    {
      id: 'support',
      icon: Headphones,
      label: 'CUSTOMER SUPPORT',
      title: 'CUSTOMER SUPPORT',
      subtitle: 'Help. Care. Guide.',
      description: 'Round-the-clock customer support to assist you with bookings, queries, and any concerns. We\'re here to ensure your car care experience is seamless.'
    }
  ];

  return (
    <section id="company" className="relative py-20 bg-white scroll-mt-20">
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_30%_70%,rgba(59,130,246,0.05),transparent_50%)]"></div>
      <div className="relative z-10 max-w-[1200px] mx-auto px-5">
        <h2 className="text-center text-3xl md:text-4xl font-bold mb-8 text-gray-800 px-4">Why You Should Choose GoCarShine</h2>
        <p className="text-center text-lg text-gray-600 leading-relaxed mb-4 max-w-[900px] mx-auto">
          At GoCarShine, we make your car care experience effortless and transparent. Get real-time photo updates of your vehicle as it's cleaned, so you always know the progress. Enjoy free expert consultations to help you choose the best cleaning and detailing services for your car. And with our value-for-money packages, you get premium care without breaking the bank.
        </p>
        <p className="text-center text-lg text-gray-600 leading-relaxed mb-16 max-w-[900px] mx-auto">
          We combine convenience, quality, and trust—so your car always gets the care it deserves.
        </p>

        <div className="flex flex-col md:flex-row gap-0 bg-white rounded-2xl shadow-lg border border-gray-200 overflow-hidden mt-16">
          <div className="flex md:flex-col w-full md:w-64 bg-gray-50 overflow-x-auto md:overflow-x-visible">
            {tabs.map((tab) => (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`flex items-center px-4 py-6 border-b md:border-b md:border-r-0 last:border-b-0 border-gray-200 transition-all text-left min-w-[120px] md:min-w-0 ${
                  activeTab === tab.id
                    ? 'bg-gradient-to-r from-blue-600 to-blue-700 text-white shadow-lg'
                    : 'bg-transparent text-gray-600 hover:bg-gray-100 hover:text-gray-800'
                }`}
              >
                <tab.icon className="w-5 h-5 mr-4 flex-shrink-0" />
                <span className="text-sm font-semibold leading-tight">{tab.label}</span>
              </button>
            ))}
          </div>

          <div className="flex-1 bg-white p-8 min-h-[300px]">
            {tabs.map((tab) => (
              <div
                key={tab.id}
                className={`transition-opacity duration-300 ${activeTab === tab.id ? 'block' : 'hidden'}`}
              >
                <h3 className="text-3xl font-bold mb-4 text-gray-800 text-center">{tab.title}</h3>
                <p className="text-lg font-semibold bg-gradient-to-r from-blue-600 to-blue-700 bg-clip-text text-transparent mb-6 text-center">{tab.subtitle}</p>
                <p className="text-base text-gray-600 leading-relaxed text-center">{tab.description}</p>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
};

export default WhyChooseUs;
