import Header from '../components/Header';
import Hero from '../components/Hero';
import Cities from '../components/Cities';
import Features from '../components/Features';
import OurTeam from '../components/OurTeam';
import Services from '../components/Services';
import Packages from '../components/Packages';
import WhatWeOffer from '../components/WhatWeOffer';
import HowItWorks from '../components/HowItWorks';
import Testimonials from '../components/Testimonials';
import WhyChooseUs from '../components/WhyChooseUs';
import CTA from '../components/CTA';
import Footer from '../components/Footer';

export default function Home() {
  return (
    <>
      <Header />
      <Hero />
      <Cities />
      <Features />
      <OurTeam />
      <Services />
      <Packages />
      <WhatWeOffer />
      <HowItWorks />
      <Testimonials />
      <WhyChooseUs />
      <CTA />
      <Footer />
    </>
  );
}
