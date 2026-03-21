import { Droplets, Sparkles, Bell } from 'lucide-react';

const Services = () => {
  const services = [
    {
      icon: Droplets,
      title: 'Deep Wash',
      description: 'Get your car sparkling clean in record time without compromising on quality. Perfect for a quick refresh before an important meeting or weekend trip.',
      image: '/Capture2.PNG'
    },
    {
      icon: Sparkles,
      title: 'Deluxe Detailing',
      description: 'A full inside-and-out deep clean that leaves no spot untouched. Perfect for those who want their car to look, feel, and smell brand new.',
      image: '/Capture3.PNG'
    },
    {
      icon: Bell,
      title: 'Real Time Updates',
      description: 'Our team comes to you—home, office, or anywhere—equipped with everything needed to give your car a full professional clean on the spot.',
      image: '/75987d6a-7fb3-4be8-8fdd-2c4c1b803fb9.png'
    }
  ];

  return (
    <section id="services" className="relative py-20 bg-gradient-to-b from-gray-50 to-white scroll-mt-20">
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_30%_20%,rgba(59,130,246,0.05),transparent_50%)]"></div>
      <div className="relative z-10 max-w-[1200px] mx-auto px-5">
        <h2 className="text-center text-3xl md:text-4xl font-bold mb-4 text-gray-800 px-4">Our Premium Services</h2>
        <p className="text-center text-xl text-gray-600 mb-16 max-w-[800px] mx-auto">
          From quick touch-ups to full detailing, everything your car needs under one roof.
        </p>
        <div className="grid md:grid-cols-3 gap-8">
          {services.map((service, index) => (
            <div
              key={index}
              className="bg-white rounded-2xl overflow-hidden shadow-lg transition-all hover:-translate-y-3 hover:shadow-2xl border border-gray-200"
            >
              <div className="relative h-48 overflow-hidden">
                <img
                  src={service.image}
                  alt={service.title}
                  className="w-full h-full object-cover transition-transform hover:scale-110 duration-500"
                />
                <div className="absolute top-4 right-4 w-16 h-16 bg-gradient-to-br from-blue-600 to-blue-700 rounded-full flex items-center justify-center shadow-xl">
                  <service.icon className="w-8 h-8 text-white" />
                </div>
              </div>
              <div className="p-8 text-center">
                <h3 className="text-2xl font-bold mb-4 text-gray-800">{service.title}</h3>
                <p className="text-gray-600 leading-relaxed">{service.description}</p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Services;
