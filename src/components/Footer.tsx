const Footer = () => {
  return (
    <footer id="contactus" className="relative bg-gray-50 text-gray-800 py-16 scroll-mt-20 border-t border-gray-200">
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_50%_0%,rgba(59,130,246,0.03),transparent_50%)]"></div>
      <div className="relative z-10 max-w-[1200px] mx-auto px-5">
        <div className="grid md:grid-cols-3 gap-12 mb-8">
          <div>
            <h3 className="mb-4 bg-gradient-to-r from-blue-600 to-blue-700 bg-clip-text text-transparent text-xl font-bold">GoCarShine</h3>
            <div className="flex flex-col gap-2">
              <a href="#home" className="text-gray-600 hover:text-blue-600 transition-colors">Home</a>
              <a href="#services" className="text-gray-600 hover:text-blue-600 transition-colors">Services</a>
              <a href="#partner" className="text-gray-600 hover:text-blue-600 transition-colors">Partner With Us</a>
              <a href="#channel-partner" className="text-gray-600 hover:text-blue-600 transition-colors">Channel Partner</a>
              <a href="#about" className="text-gray-600 hover:text-blue-600 transition-colors">About us</a>
              <a href="#reviews" className="text-gray-600 hover:text-blue-600 transition-colors">Reviews</a>
              <a href="#blogs" className="text-gray-600 hover:text-blue-600 transition-colors">Blogs</a>
              <a href="/GoCarShine_Terms_and_Conditions.pdf" target="_blank" rel="noopener noreferrer" className="text-gray-600 hover:text-blue-600 transition-colors">Terms & Conditions</a>
              <a href="/GoCarShine_Refund.pdf" target="_blank" rel="noopener noreferrer" className="text-gray-600 hover:text-blue-600 transition-colors">Refund & Cancellation Policy</a>
              <a href="/GoCarShine_Privacy_Policy.pdf" target="_blank" rel="noopener noreferrer" className="text-gray-600 hover:text-blue-600 transition-colors">Privacy Policy</a>
            </div>
          </div>
          <div>
            <h4 className="mb-4 bg-gradient-to-r from-blue-600 to-blue-700 bg-clip-text text-transparent text-lg font-bold">Services</h4>
            <div className="flex flex-col gap-2">
              <a href="#" className="text-gray-600 hover:text-blue-600 transition-colors">Car Wash Mumbai</a>
              <a href="#" className="text-gray-600 hover:text-blue-600 transition-colors">Car Wash Delhi</a>
              <a href="#" className="text-gray-600 hover:text-blue-600 transition-colors">Car Wash Bangalore</a>
            </div>
          </div>
          <div>
            <h4 className="mb-4 bg-gradient-to-r from-blue-600 to-blue-700 bg-clip-text text-transparent text-lg font-bold">Contact</h4>
            <div className="text-gray-600 space-y-2">
              <p><strong className="text-gray-800">Phone:</strong> +917505412272</p>
              <p><strong className="text-gray-800">Mail:</strong> support@gocarshine.com</p>
              <p><strong className="text-gray-800">Location:</strong> Gaur Yamuna City, Greater Noida</p>
            </div>
          </div>
        </div>
        <div className="border-t border-gray-200 pt-8 text-center text-gray-500 text-sm space-y-2">
          <p>By continuing past this page, you agree to our Terms of Service, Cookie Policy, Privacy Policy and Content Policies</p>
          <p>&copy; 2025 Managed by AIGlobalSolutions.net.in All Rights Reserved</p>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
