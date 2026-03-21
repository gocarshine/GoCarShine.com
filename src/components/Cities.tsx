const Cities = () => {
  const cities = [
    'Noida', 'Greater Noida', 'Noida Extension','Ghaziabad', 'Gurugram', 'Agra', 'Kanpur',
    'Firozabad', 'Faridabad', 'New Delhi', 'Mathura', 'Mumbai', 'Pune','Rohtak'
  ];

  return (
    <section id="location" className="py-20 bg-[#2b2b2b] scroll-mt-20">
      <div className="max-w-[1200px] mx-auto px-5">
        <h2 className="text-center text-3xl md:text-4xl font-bold mb-12 text-[#e0e0e0] px-4">Upcoming Location at</h2>
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4 mb-8">
          {cities.map((city, index) => (
            <div
              key={index}
              className="bg-[#3a3a3a] p-4 text-center rounded-lg text-[#e0e0e0] shadow-lg transition-all hover:-translate-y-1 hover:shadow-xl hover:bg-gradient-to-br hover:from-[#667eea] hover:to-[#764ba2] hover:text-white font-medium cursor-pointer"
            >
              {city}
            </div>
          ))}
        </div>
        <p className="text-center text-lg text-[#e0e0e0]">
          Is your city missing? Become a GoCarShine Partner write to <a href="#partner" className="text-[#ff8c00] font-semibold hover:underline"> admin@gocarshine.com </a>
        </p>
      </div>
    </section>
  );
};

export default Cities;
