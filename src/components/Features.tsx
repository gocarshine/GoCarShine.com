import { Smartphone, Shield, Star } from 'lucide-react';

const Features = () => {
  return (
    <section id="aboutus" className="relative py-20 bg-white scroll-mt-20">
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_50%_50%,rgba(59,130,246,0.03),transparent_70%)]"></div>
      <div className="relative z-10 max-w-[1200px] mx-auto px-5">
        <h2 className="text-center text-3xl md:text-4xl font-bold mb-8 text-gray-800 px-4">Clean and Hygiene With GoCarShine The Cleaning Company</h2>
        <p className="text-center text-lg text-gray-600 leading-relaxed mb-12 max-w-[800px] mx-auto">
          We're a destination for car enthusiasts and everyday drivers alike. Step into our world of premium car care and experience the difference that attention to detail and cutting-edge technology can make.
        </p>
        <div className="flex justify-center gap-12 flex-wrap">
          <div className="flex items-center gap-4 text-lg font-medium text-gray-800 group cursor-pointer">
            <div className="p-3 bg-gradient-to-br from-blue-600 to-blue-700 rounded-xl shadow-lg group-hover:shadow-xl transition-all">
              <Smartphone className="w-6 h-6 text-white" />
            </div>
            <span>Real Time Updates</span>
          </div>
          <div className="flex items-center gap-4 text-lg font-medium text-gray-800 group cursor-pointer">
            <div className="p-3 bg-gradient-to-br from-blue-600 to-blue-700 rounded-xl shadow-lg group-hover:shadow-xl transition-all">
              <Shield className="w-6 h-6 text-white" />
            </div>
            <span>Hassle Free</span>
          </div>
          <div className="flex items-center gap-4 text-lg font-medium text-gray-800 group cursor-pointer">
            <div className="p-3 bg-gradient-to-br from-blue-600 to-blue-700 rounded-xl shadow-lg group-hover:shadow-xl transition-all">
              <Star className="w-6 h-6 text-white" />
            </div>
            <span>Premium Care</span>
          </div>
        </div>
      </div>
    </section>
  );
};

export default Features;
