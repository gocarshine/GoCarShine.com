import { Phone, CalendarCheck, ListChecks } from 'lucide-react';

const HowItWorks = () => {
  const steps = [
    {
      number: 1,
      icon: Phone,
      title: 'Call Us',
      description: 'Speak to our friendly team to discuss your car\'s needs and get quick assistance.'
    },
    {
      number: 2,
      icon: CalendarCheck,
      title: 'Schedule Consultation',
      description: 'Choose a convenient date and time for a detailed assessment of your vehicle.'
    },
    {
      number: 3,
      icon: ListChecks,
      title: 'Select Service',
      description: 'Pick from our range of premium cleaning and detailing packages to suit your style and budget.'
    }
  ];

  return (
    <section className="py-20 bg-[#3a3a3a]">
      <div className="max-w-[1200px] mx-auto px-5">
        <h2 className="text-center text-4xl font-bold mb-8 text-[#e0e0e0]">Book in 3 Easy Steps</h2>
        <p className="text-center text-xl text-[#b0b0b0] mb-16 max-w-[600px] mx-auto">
          From call to clean — your car's perfect shine is just three steps away.
        </p>
        <div className="grid md:grid-cols-3 gap-12">
          {steps.map((step) => (
            <div
              key={step.number}
              className="text-center p-8 bg-[#2b2b2b] rounded-2xl shadow-xl transition-transform hover:-translate-y-3 relative"
            >
              <div className="absolute -top-4 left-1/2 -translate-x-1/2 w-8 h-8 bg-gradient-to-br from-[#ff6b6b] to-[#ff5252] text-white rounded-full flex items-center justify-center font-bold text-lg">
                {step.number}
              </div>
              <div className="w-20 h-20 bg-gradient-to-br from-[#00bcd4] to-[#0097a7] rounded-full flex items-center justify-center mx-auto mb-6">
                <step.icon className="w-10 h-10 text-white" />
              </div>
              <h3 className="text-2xl font-bold mb-4 text-[#e0e0e0]">{step.title}</h3>
              <p className="text-[#b0b0b0] leading-relaxed">{step.description}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default HowItWorks;
