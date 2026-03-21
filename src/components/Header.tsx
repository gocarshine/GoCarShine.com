import { useState, useRef, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { Phone, ChevronDown, User, LogOut, LayoutDashboard } from 'lucide-react';

const Header = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [isDropdownOpen, setIsDropdownOpen] = useState(false);
  const { user, signOut } = useAuth();
  const navigate = useNavigate();
  const dropdownRef = useRef<HTMLDivElement>(null);

  const handleNavClick = (e: React.MouseEvent<HTMLAnchorElement>, href: string) => {
    e.preventDefault();
    const target = document.querySelector(href);
    if (target) {
      target.scrollIntoView({ behavior: 'smooth', block: 'start' });
      setIsMenuOpen(false);
    }
  };

  const handleHomeClick = (e: React.MouseEvent<HTMLAnchorElement>) => {
    e.preventDefault();
    navigate('/');
    setIsMenuOpen(false);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handleLogout = async () => {
    try {
      setIsDropdownOpen(false);
      await signOut();
      setTimeout(() => {
        navigate('/', { replace: true });
        window.location.href = '/';
      }, 100);
    } catch (error) {
      console.error('Logout error:', error);
      navigate('/', { replace: true });
    }
  };

  const getUserDisplayName = () => {
    if (!user?.email) return 'User';
    return user.email.split('@')[0];
  };

  const formatLastLogin = () => {
    if (!user?.last_sign_in_at) return 'N/A';
    const date = new Date(user.last_sign_in_at);
    return date.toLocaleString('en-US', {
      month: 'short',
      day: 'numeric',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsDropdownOpen(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  return (
    <header
      className="fixed top-0 w-full z-[1000] shadow-[0_4px_30px_rgba(0,0,0,0.4)] bg-blue-700 backdrop-blur-md border-b border-white/10"
    >
      <nav className="py-4 bg-gradient-to-r from-blue-600 to-blue-700">
        <div className="w-full px-5 lg:px-8 flex justify-between items-center">
          <div className="nav-logo cursor-pointer flex-shrink-0 mr-4 md:mr-8 lg:mr-12" onClick={() => navigate('/')}>
            <img
              src="/logo1.png"
              alt="GoCarShine Logo"
              className="h-20 md:h-24 lg:h-28 w-auto hover:opacity-90 transition-opacity"
            />
          </div>

          <div className={`
            md:flex md:gap-4 lg:gap-8
            ${isMenuOpen ? 'flex' : 'hidden'}
            fixed md:relative left-0 top-[60px] md:top-0
            flex-col md:flex-row
            bg-blue-700 md:bg-transparent
            w-full md:w-auto
            text-center md:text-left
            py-8 md:py-0
            shadow-lg md:shadow-none
            max-h-[calc(100vh-60px)] md:max-h-none
            overflow-y-auto md:overflow-visible
          `}>
            <a href="/" onClick={handleHomeClick} className="text-white text-sm md:text-base font-medium transition-colors hover:text-[#00bcd4] py-3 md:py-0">Home</a>
            <a href="#aboutus" onClick={(e) => handleNavClick(e, '#aboutus')} className="text-white text-sm md:text-base font-medium transition-colors hover:text-[#00bcd4] py-3 md:py-0">About Us</a>
            <a href="#ourteam" onClick={(e) => handleNavClick(e, '#ourteam')} className="text-white text-sm md:text-base font-medium transition-colors hover:text-[#00bcd4] py-3 md:py-0">Our Team</a>
            <a href="#packages" onClick={(e) => handleNavClick(e, '#packages')} className="text-white text-sm md:text-base font-medium transition-colors hover:text-[#00bcd4] py-3 md:py-0">Services/Packages</a>
            <a href="#company" onClick={(e) => handleNavClick(e, '#company')} className="text-white text-sm md:text-base font-medium transition-colors hover:text-[#00bcd4] py-3 md:py-0">Company</a>
            <a href="#location" onClick={(e) => handleNavClick(e, '#location')} className="text-white text-sm md:text-base font-medium transition-colors hover:text-[#00bcd4] py-3 md:py-0">Location</a>
            <a href="#contactus" onClick={(e) => handleNavClick(e, '#contactus')} className="text-white text-sm md:text-base font-medium transition-colors hover:text-[#00bcd4] py-3 md:py-0 flex flex-col md:flex-row items-center gap-2 justify-center md:justify-start">
              Contact Us
              <span className="flex md:hidden lg:flex items-center gap-1 text-xs md:text-sm">
                <Phone className="w-3 h-3 md:w-4 md:h-4" />
                +917505412272
              </span>
            </a>
            {user ? (
              <>
                <div className="md:hidden text-[#00bcd4] text-sm font-semibold py-2 border-t border-gray-600 mt-2">
                  {getUserDisplayName()}
                </div>
                <button
                  onClick={() => {
                    navigate('/dashboard');
                    setIsMenuOpen(false);
                  }}
                  className="md:hidden text-white text-sm font-medium transition-colors hover:text-[#00bcd4] py-3 flex items-center justify-center gap-2"
                >
                  <User className="w-4 h-4" />
                  Profile
                </button>
                <button
                  onClick={() => {
                    handleLogout();
                    setIsMenuOpen(false);
                  }}
                  className="md:hidden text-red-400 text-sm font-medium transition-colors hover:text-red-300 py-3 flex items-center justify-center gap-2"
                >
                  <LogOut className="w-4 h-4" />
                  Logout
                </button>
              </>
            ) : (
              <button
                onClick={() => {
                  navigate('/login');
                  setIsMenuOpen(false);
                }}
                className="md:hidden text-white text-sm font-medium transition-colors hover:text-[#00bcd4] py-3"
              >
                Sign In
              </button>
            )}
          </div>

          <div className="flex items-center gap-4">
            {user ? (
              <div className="hidden md:block relative" ref={dropdownRef}>
                <button
                  onClick={() => setIsDropdownOpen(!isDropdownOpen)}
                  className="flex items-center gap-2 text-white text-sm md:text-base font-medium transition-colors hover:text-[#00bcd4] px-3 py-2 rounded-lg hover:bg-white/10"
                >
                  <span>{getUserDisplayName()}</span>
                  <ChevronDown className={`w-4 h-4 transition-transform ${isDropdownOpen ? 'rotate-180' : ''}`} />
                </button>

                {isDropdownOpen && (
                  <div className="absolute right-0 mt-2 w-64 bg-white rounded-lg shadow-lg py-2 border border-gray-200">
                    <div className="px-4 py-3 border-b border-gray-200">
                      <div className="flex items-center gap-2 mb-2">
                        <User className="w-4 h-4 text-gray-500" />
                        <span className="text-xs font-semibold text-gray-500 uppercase">User Info</span>
                      </div>
                      <div className="space-y-1">
                        <div className="text-xs text-gray-600">
                          <span className="font-medium">Email:</span>
                          <div className="text-gray-800 text-[11px] break-all">{user?.email || 'N/A'}</div>
                        </div>
                        <div className="text-xs text-gray-600">
                          <span className="font-medium">Last Login:</span>
                          <div className="text-gray-800">{formatLastLogin()}</div>
                        </div>
                      </div>
                    </div>
                    <button
                      onClick={() => {
                        navigate('/dashboard');
                        setIsDropdownOpen(false);
                      }}
                      className="w-full flex items-center gap-2 px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors"
                    >
                      <LayoutDashboard className="w-4 h-4" />
                      <span>Dashboard</span>
                    </button>
                    <button
                      onClick={handleLogout}
                      className="w-full flex items-center gap-2 px-4 py-2 text-sm text-red-600 hover:bg-red-50 transition-colors"
                    >
                      <LogOut className="w-4 h-4" />
                      <span>Logout</span>
                    </button>
                  </div>
                )}
              </div>
            ) : (
              <button
                onClick={() => navigate('/login')}
                className="hidden md:block text-white text-sm md:text-base font-medium transition-colors hover:text-[#00bcd4]"
              >
                Sign In
              </button>
            )}
            <button
              className="md:hidden flex flex-col cursor-pointer"
              onClick={() => setIsMenuOpen(!isMenuOpen)}
            >
              <span className={`w-6 h-0.5 bg-white my-0.5 transition-transform ${isMenuOpen ? 'translate-y-2 rotate-45' : ''}`}></span>
              <span className={`w-6 h-0.5 bg-white my-0.5 transition-opacity ${isMenuOpen ? 'opacity-0' : ''}`}></span>
              <span className={`w-6 h-0.5 bg-white my-0.5 transition-transform ${isMenuOpen ? '-translate-y-2 -rotate-45' : ''}`}></span>
            </button>
          </div>
        </div>
      </nav>
    </header>
  );
};

export default Header;
