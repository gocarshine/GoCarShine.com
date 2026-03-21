const OurTeam = () => {
  const teamMembers = [
    {
      name: "KV K Narayan",
      position: "Co-Founder, GoCarShine.com",
      credentials: ["VP AIGlobalSoluions| Entrepreneur", "Chairperson, Narayana Institutions"],
      bio: [
        "KV K NNarayan is a seasoned Merchant Navy Captain and entrepreneur with strong expertise in leadership, operations, and strategic execution. Drawing from global maritime experience, he co-founded GoCarShine.com with a vision to deliver reliable, eco-friendly, and customer-centric doorstep car care services.",
        "As Chairperson of TDKS Institutions, he is committed to quality education, skill development, and preparing future-ready professionals through value-based learning."
      ],
      image: "/img-20251215-wa00.jpg"
    },
    {
      name: "Ashish K Narayan",
      position: "Co-Founder, GoCarShine.com",
      credentials: ["Automobile Industry Professional | 20+ Years Experience"],
      bio: [
        "Ashish K Narayan is a seasoned automobile industry professional with over 20 years of hands-on experience in vehicle operations, service management, and customer-focused solutions. As Co-Founder of GoCarShine.com, he brings deep industry insight and operational expertise, playing a key role in delivering high-quality, reliable, and efficient doorstep car care services.",
        "His strong understanding of automotive processes, service standards, and customer expectations helps drive consistent service excellence and long-term growth for the GoCarShine.com brand."
      ],
      image: "/Ashish K Narayan.jpg"
    }
  ];

  return (
    <section id="ourteam" className="py-20 bg-[#0a0a0a] scroll-mt-20">
      <div className="container mx-auto px-4">
        <h2 className="text-4xl md:text-5xl font-bold text-white text-center mb-4">
          Our <span className="text-[#00d4ff]">Team</span>
        </h2>
        <p className="text-[#b0b0b0] text-center mb-16 max-w-2xl mx-auto">
          Meet the leaders driving innovation and excellence at GoCarShine
        </p>

        <div className="max-w-7xl mx-auto space-y-8">
          {teamMembers.map((member, index) => (
            <div key={index} className="bg-gradient-to-br from-[#1a1a1a] to-[#0f0f0f] rounded-2xl overflow-hidden shadow-2xl border border-[#00d4ff]/20 hover:border-[#00d4ff]/40 transition-all duration-300">
              <div className="flex flex-col md:flex-row">
                <div className="relative w-full md:w-2/5 lg:w-1/3 h-[400px] md:h-auto bg-[#0a0a0a] flex items-center justify-center flex-shrink-0">
                  <img
                    src={member.image}
                    alt={member.name}
                    className="w-full h-full object-contain p-4"
                  />
                </div>

                <div className="p-8 flex-1">
                  <h3 className="text-2xl font-bold text-white mb-2">
                    {member.name}
                  </h3>

                  <div className="mb-4">
                    <p className="text-[#00d4ff] font-semibold mb-1">{member.position}</p>
                    {member.credentials.map((credential, idx) => (
                      <p key={idx} className="text-[#b0b0b0] text-sm">{credential}</p>
                    ))}
                  </div>

                  <div className="space-y-3 text-[#b0b0b0] text-sm leading-relaxed">
                    {member.bio.map((paragraph, idx) => (
                      <p key={idx}>{paragraph}</p>
                    ))}
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default OurTeam;
