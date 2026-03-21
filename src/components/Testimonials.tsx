import { Star } from 'lucide-react';

const Testimonials = () => {
  const testimonials = [
    {
      rating: 4.4,
      text: "I've been a loyal customer of GoCarShine for years, and their attention to detail never fails to impress me. My car always looks brand new after a visit!",
      author: 'Gaurav Dimaniya',
      position: 'Investment Advisor - Shining Bulls'
    },
    {
      rating: 4.7,
      text: "GoCarShine's wash service is a game-changer for my busy schedule. I love that they can come to me and leave my car spotless while I focus on other things.",
      author: 'Vikas Jasrotia',
      position: 'IB Officer'
    },
    {
      rating: 4.9,
      text: "Outstanding service! The team at GoCarShine goes above and beyond to ensure customer satisfaction. Highly recommended for anyone who values quality.",
      author: 'Ravi Y',
      position: 'IT Professional'
    }
  ];

  return (
    <section className="py-20 bg-[#2b2b2b]">
      <div className="max-w-[1200px] mx-auto px-5">
        <h2 className="text-center text-4xl font-bold mb-16 text-[#e0e0e0]">What Our Clients Say</h2>
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
          {testimonials.map((testimonial, index) => (
            <div
              key={index}
              className="bg-[#3a3a3a] p-8 rounded-2xl shadow-xl"
            >
              <div className="flex items-center gap-2 mb-4">
                {[...Array(5)].map((_, i) => (
                  <Star key={i} className="w-5 h-5 text-[#ff8c00] fill-[#ff8c00]" />
                ))}
                <span className="ml-2 font-semibold text-[#e0e0e0]">{testimonial.rating}</span>
              </div>
              <p className="italic mb-4 leading-relaxed text-[#b0b0b0]">{testimonial.text}</p>
              <div className="text-[#ff8c00] font-semibold">
                <strong>{testimonial.author}</strong>
                <span className="block text-sm text-[#b0b0b0] font-normal mt-1">{testimonial.position}</span>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Testimonials;
