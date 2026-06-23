import { useState, useEffect } from 'react'
import { ArrowUpRight, Award, Crown, X } from 'lucide-react'

const NAV_LINKS = ['Projects', 'Studio', 'Offerings', 'Inquire']

const STATS = [
  { value: '250+', label: 'Brands Transformed' },
  { value: '95%', label: 'Client Retention' },
  { value: '10+', label: 'Years in the Game' },
]

export default function App() {
  const [menuOpen, setMenuOpen] = useState(false)

  // Lock body scroll when mobile menu is open
  useEffect(() => {
    if (menuOpen) {
      document.body.style.overflow = 'hidden'
    } else {
      document.body.style.overflow = 'hidden'
    }
    return () => {
      document.body.style.overflow = 'hidden'
    }
  }, [menuOpen])

  return (
    <section className="relative h-screen w-full overflow-hidden">
      {/* ===== BACKGROUND VIDEO ===== */}
      <video
        autoPlay
        muted
        loop
        playsInline
        preload="auto"
        className="absolute inset-0 h-full w-full object-cover"
      >
        <source
          src="https://d8j0ntlcm91z4.cloudfront.net/user_38xzZboKViGWJOttwIXH07lWA1P/hf_20260606_154941_df1a96e1-a06f-450c-bd02-d863414cc1a0.mp4"
          type="video/mp4"
        />
      </video>

      {/* ===== DARK OVERLAY ===== */}
      <div className="absolute inset-0 z-10 bg-black/50" />

      {/* ===== CONTENT LAYER ===== */}
      <div className="relative z-20 flex h-full flex-col">
        {/* ----- NAVBAR ----- */}
        <nav className="flex w-full items-center justify-between px-6 py-5 sm:px-10 lg:px-16 lg:py-7">
          {/* Brand */}
          <div className="font-podium text-2xl font-bold uppercase tracking-wider text-white sm:text-3xl">
            VANGUARD
          </div>

          {/* Center Nav Links (md+) */}
          <div className="hidden items-center gap-10 md:flex">
            {NAV_LINKS.map((link) => (
              <a
                key={link}
                href="#"
                className="font-inter text-sm uppercase tracking-widest text-white/80 transition hover:text-white"
              >
                {link}
              </a>
            ))}
          </div>

          {/* Desktop CTA (md+) */}
          <a
            href="#"
            className="hidden items-center gap-2 border border-white/30 px-6 py-3 font-inter text-xs uppercase tracking-widest text-white transition hover:border-white/60 hover:bg-white/10 md:flex"
          >
            GET IN TOUCH
            <ArrowUpRight className="h-4 w-4" />
          </a>

          {/* Hamburger (mobile) */}
          <button
            onClick={() => setMenuOpen(true)}
            className="flex flex-col items-end space-y-1.5 md:hidden"
            aria-label="Open menu"
          >
            <div className="h-0.5 w-6 bg-white" />
            <div className="h-0.5 w-6 bg-white" />
            <div className="h-0.5 w-4 bg-white" />
          </button>
        </nav>

        {/* ----- MOBILE MENU OVERLAY ----- */}
        <div
          className={`fixed inset-0 z-50 bg-black/95 backdrop-blur-sm transition-all duration-500 md:hidden ${
            menuOpen ? 'visible opacity-100' : 'invisible opacity-0'
          }`}
        >
          {/* Overlay Header */}
          <div className="flex w-full items-center justify-between px-6 py-5 sm:px-10">
            <div className="font-podium text-2xl font-bold uppercase tracking-wider text-white sm:text-3xl">
              VANGUARD
            </div>
            <button
              onClick={() => setMenuOpen(false)}
              aria-label="Close menu"
            >
              <X className="h-6 w-6 text-white" />
            </button>
          </div>

          {/* Overlay Links */}
          <div className="flex flex-1 flex-col items-center justify-center">
            {NAV_LINKS.map((link, i) => (
              <a
                key={link}
                href="#"
                onClick={() => setMenuOpen(false)}
                className="font-podium text-4xl font-bold uppercase text-white transition-all duration-500 ease-out sm:text-5xl"
                style={{
                  transitionDelay: menuOpen ? `${i * 80 + 100}ms` : '0ms',
                  opacity: menuOpen ? 1 : 0,
                  transform: menuOpen ? 'translateY(0)' : 'translateY(20px)',
                }}
              >
                {link}
              </a>
            ))}

            {/* Overlay CTA */}
            <a
              href="#"
              onClick={() => setMenuOpen(false)}
              className="mt-10 flex items-center gap-2 border border-white/30 px-6 py-3 font-inter text-xs uppercase tracking-widest text-white transition-all duration-500 ease-out hover:border-white/60 hover:bg-white/10"
              style={{
                transitionDelay: menuOpen ? `${4 * 80 + 100}ms` : '0ms',
                opacity: menuOpen ? 1 : 0,
                transform: menuOpen ? 'translateY(0)' : 'translateY(20px)',
              }}
            >
              GET IN TOUCH
              <ArrowUpRight className="h-4 w-4" />
            </a>
          </div>
        </div>

        {/* ----- HERO CONTENT ----- */}
        <div className="flex flex-1 items-center px-6 pb-16 sm:px-10 lg:px-16">
          <div className="max-w-5xl">
            {/* Tagline */}
            <div className="animate-fade-up mb-6 flex items-center gap-3 lg:mb-8">
              <Crown className="h-4 w-4 text-white/70" />
              <span className="font-inter text-xs uppercase tracking-[0.3em] text-white/70 sm:text-sm">
                World-Class Digital Collective
              </span>
            </div>

            {/* Main Heading */}
            <div className="animate-fade-up-delay-1">
              <h1 className="font-podium text-[clamp(2.8rem,8vw,7rem)] font-bold uppercase leading-[0.92] tracking-tight text-white">
                <span className="block">Design.</span>
                <span className="block">Disrupt.</span>
                <span className="block">Conquer.</span>
              </h1>
            </div>

            {/* Subtext */}
            <div className="animate-fade-up-delay-2 mt-6 max-w-md lg:mt-8">
              <p className="font-inter text-sm leading-relaxed text-white/70 sm:text-base">
                We build fierce brand identities
                <br />
                that don&apos;t just turn heads —{' '}
                <span className="font-semibold text-white">they lead.</span>
              </p>
            </div>

            {/* CTA Row */}
            <div className="animate-fade-up-delay-3 mt-8 flex flex-wrap items-center gap-4 sm:gap-6 lg:mt-10">
              {/* Primary CTA */}
              <a
                href="#"
                className="group flex items-center gap-2 bg-black px-5 py-3 font-inter text-[11px] uppercase tracking-widest text-white transition hover:bg-neutral-900 sm:px-7 sm:py-4 sm:text-xs"
              >
                SEE OUR WORK
                <ArrowUpRight className="h-4 w-4 transition-transform group-hover:translate-x-0.5 group-hover:-translate-y-0.5" />
              </a>

              {/* Award Badge (sm+) */}
              <div className="hidden items-center gap-4 border-l border-white/30 pl-4 sm:flex">
                <Award className="h-8 w-8 text-white/50" />
                <div className="flex flex-col">
                  <span className="font-inter text-xs uppercase tracking-wider text-white/60">
                    Top-Rated
                  </span>
                  <span className="font-inter text-xs uppercase tracking-wider text-white/60">
                    Brand Studio
                  </span>
                </div>
              </div>
            </div>

            {/* Stats Row */}
            <div className="animate-fade-up-delay-4 mt-8 flex flex-wrap gap-6 sm:mt-10 sm:gap-12 lg:mt-14 lg:gap-16">
              {STATS.map((stat) => (
                <div key={stat.label} className="flex flex-col">
                  <span className="font-inter text-2xl font-bold tracking-tight text-white sm:text-4xl lg:text-5xl">
                    {stat.value}
                  </span>
                  <span className="mt-1 font-inter text-[9px] uppercase tracking-widest text-white/50 sm:text-xs">
                    {stat.label}
                  </span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}
