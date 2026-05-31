# DOCUMENTATION

- [2026-05-31]: Initial Website Setup
  - *Details*: Created a landing page and legal pages for the SafeSpot iOS application. The website is built to be modern, private-first, and compliant with Apple App Store submission requirements.
  - *Tech Notes*:
    - **Framework**: Vite used as the build tool for a multi-page static site.
    - **Language**: HTML5, Vanilla JavaScript, Vanilla CSS.
    - **Pages**: `index.html` (Landing), `privacy.html` (Privacy Policy), `terms.html` (Terms of Service), `support.html` (Support/FAQ).
    - **Styling**: `src/style.css` includes CSS variables for a dark navy/charcoal theme (`#0a0f1f`, `#171c2e`), purple primary (`#8c6bf5`), and teal secondary (`#33c7ab`). Implemented glassmorphism (`backdrop-filter`) and smooth scroll animations via IntersectionObserver in `src/main.js`.
    - **Assets**: Utilized existing `logo.png`.
    - **Build Process**: `npm run build` outputs optimized static files to the `website/dist` folder, ready for GitHub Pages hosting.

- [2026-05-31]: Aesthetic Overhaul (Senior Web Design Pass)
  - *Details*: Major visual enhancements to bring the website to a state-of-the-art premium look.
  - *Tech Notes*:
    - **Color & Gradients**: Upgraded to `oklch` color space interpolation for vibrant, non-muddy gradients, with automatic `@supports` fallbacks.
    - **Animations**: Implemented native CSS Scroll-Driven Animations (`animation-timeline: scroll()`) for the hero section's 3D mockup rotation. Added a continuous 20s spinning CSS conic-gradient orb for the background.
    - **Micro-Interactions**: Added a dynamic radial gradient hover effect (mouse tracking via JavaScript) to the feature and contact cards (`.card-hover-effect`). Added shimmer effects to the App Store button.
    - **Depth**: Replaced simple shadows with ultra-realistic, multi-layered CSS drop-shadows and box-shadows.
    - **Typography**: Refactored heading sizing using aggressive `clamp()` functions for seamless fluidity between desktop and mobile.

- [2026-05-31]: Fixed 404 Links for GitHub Pages Deployment
  - *Details*: Converted absolute links to relative links across all HTML files so navigation works correctly regardless of the repository base path.
  - *Tech Notes*: Updated `index.html`, `privacy.html`, `terms.html`, and `support.html` inside `website/` and ran `npm run build`.

- [2026-05-31]: Replaced relative links with absolute SafeSpotter base paths
  - *Details*: To prevent routing issues caused by missing trailing slashes on GitHub Pages, all `href` links were changed to use absolute base paths (`/SafeSpotter/...`). `vite.config.js` was also updated to use `base: '/SafeSpotter/'`.
  - *Tech Notes*: Updated `vite.config.js` and all HTML files in `website/`, rebuilt with `npm run build`, and pushed the commit.

- [2026-05-31]: Created Project README
  - *Details*: Authored a comprehensive and professional README.md in English for the SafeSpot repository.
  - *Tech Notes*: Based the content entirely on the existing `specifiche.md` and the implemented codebase (SwiftData, Face ID, local notifications, SwiftUI architecture).
