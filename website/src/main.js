/* SafeSpotter site behaviour. No dependencies, no third-party calls. */

const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)');

/* --- Theme ----------------------------------------------------------------- */

function initTheme() {
  const toggle = document.querySelector('[data-theme-toggle]');
  if (!toggle) return;

  const sync = () => {
    const isLight = document.documentElement.dataset.theme === 'light';
    toggle.setAttribute('aria-pressed', String(isLight));
    toggle.setAttribute('aria-label', isLight ? 'Switch to dark theme' : 'Switch to light theme');
  };

  toggle.addEventListener('click', () => {
    const next = document.documentElement.dataset.theme === 'light' ? 'dark' : 'light';
    document.documentElement.dataset.theme = next;
    try {
      localStorage.setItem('safespotter-theme', next);
    } catch (error) {
      /* storage blocked — the choice simply won't persist */
    }
    sync();
  });

  sync();
}

/* --- Header ---------------------------------------------------------------- */

function initHeader() {
  const head = document.querySelector('.site-head');
  const toggle = document.querySelector('[data-menu-toggle]');
  const panel = document.querySelector('[data-menu-panel]');

  if (head) {
    const onScroll = () => head.classList.toggle('is-stuck', window.scrollY > 8);
    onScroll();
    window.addEventListener('scroll', onScroll, { passive: true });
  }

  if (!toggle || !panel) return;

  const setOpen = (open) => {
    panel.hidden = !open;
    toggle.setAttribute('aria-expanded', String(open));
    toggle.setAttribute('aria-label', open ? 'Close menu' : 'Open menu');
  };

  toggle.addEventListener('click', () => setOpen(panel.hidden));
  panel.addEventListener('click', (event) => {
    if (event.target.closest('a')) setOpen(false);
  });
  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && !panel.hidden) {
      setOpen(false);
      toggle.focus();
    }
  });
  window.matchMedia('(min-width: 60rem)').addEventListener('change', (event) => {
    if (event.matches) setOpen(false);
  });
}

/* --- Scroll reveals -------------------------------------------------------- */

function initReveals() {
  const targets = document.querySelectorAll('.reveal');
  if (!targets.length) return;

  if (reduceMotion.matches || !('IntersectionObserver' in window)) {
    targets.forEach((el) => el.classList.add('is-in'));
    return;
  }

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting) return;
        entry.target.classList.add('is-in');
        observer.unobserve(entry.target);
      });
    },
    { rootMargin: '0px 0px -8% 0px', threshold: 0.08 }
  );

  targets.forEach((el) => observer.observe(el));
}

/* --- Hero: the saved-location card ----------------------------------------- */

const EXAMPLES = [
  {
    name: 'Passport',
    icon: 'documents',
    tag: 'Last checked · 12 Mar',
    path: ['Home', 'Study', 'Filing cabinet', 'Blue folder, behind the deeds'],
  },
  {
    name: 'Spare keys',
    icon: 'keys',
    tag: 'Last checked · 4 Jan',
    path: ['Parents’ house', 'Kitchen', 'Third drawer', 'Taped under the cutlery tray'],
  },
  {
    name: 'Emergency cash',
    icon: 'money',
    tag: 'Highly private',
    path: ['Home', 'Bedroom', 'Wardrobe', 'Inside the left winter boot'],
  },
  {
    name: 'Backup drive',
    icon: 'electronics',
    tag: 'Last checked · 28 Feb',
    path: ['Office', 'Desk', 'Bottom drawer', 'Grey pouch, under the cables'],
  },
];

function initFindCard() {
  const card = document.querySelector('[data-find]');
  if (!card) return;

  const nameEl = card.querySelector('[data-find-name]');
  const tagEl = card.querySelector('[data-find-tag]');
  const pathEl = card.querySelector('[data-find-path]');
  const iconEl = card.querySelector('[data-find-icon]');
  if (!nameEl || !tagEl || !pathEl || !iconEl) return;

  let index = 0;
  let timer = null;
  let paused = false;
  let dots = [];

  const render = (example) => {
    nameEl.textContent = example.name;
    tagEl.textContent = example.tag;
    iconEl.setAttribute('href', `#i-${example.icon}`);
    pathEl.innerHTML = '';
    example.path.forEach((segment, i) => {
      const li = document.createElement('li');
      li.textContent = segment;
      if (i === example.path.length - 1) li.classList.add('is-target');
      li.style.animation = 'none';
      pathEl.append(li);
    });
    dots.forEach((dot, i) => {
      dot.setAttribute('aria-current', String(EXAMPLES[i] === example));
    });
  };

  // Examples wrap differently at narrow widths, so reserve the tallest height
  // once and keep it: the card must never resize under the reader.
  const lockHeight = () => {
    card.style.minHeight = '';
    let tallest = 0;
    EXAMPLES.forEach((example) => {
      render(example);
      tallest = Math.max(tallest, card.getBoundingClientRect().height);
    });
    render(EXAMPLES[index]);
    card.style.minHeight = `${Math.ceil(tallest)}px`;
  };

  const advance = () => {
    index = (index + 1) % EXAMPLES.length;
    card.classList.add('is-swapping');
    window.setTimeout(() => {
      render(EXAMPLES[index]);
      card.classList.remove('is-swapping');
    }, 200);
  };

  const stop = () => {
    window.clearInterval(timer);
    timer = null;
  };

  const start = () => {
    if (timer || paused || reduceMotion.matches) return;
    timer = window.setInterval(advance, 5200);
  };

  // Picking an example by hand takes over from the rotation for good.
  const buildDots = () => {
    const nav = document.createElement('div');
    nav.className = 'find__dots';
    nav.setAttribute('role', 'group');
    nav.setAttribute('aria-label', 'Saved item examples');

    dots = EXAMPLES.map((example, i) => {
      const dot = document.createElement('button');
      dot.type = 'button';
      dot.className = 'find__dot';
      dot.setAttribute('aria-label', `Show the ${example.name.toLowerCase()} example`);
      dot.addEventListener('click', () => {
        paused = true;
        stop();
        index = i;
        render(EXAMPLES[i]);
      });
      nav.append(dot);
      return dot;
    });

    card.append(nav);
  };

  buildDots();
  // The first example is already in the markup, with its entrance animation
  // running — only the dots need syncing.
  dots.forEach((dot, i) => dot.setAttribute('aria-current', String(i === index)));

  card.addEventListener('mouseenter', () => stop());
  card.addEventListener('mouseleave', () => start());
  card.addEventListener('focusin', () => stop());
  card.addEventListener('focusout', () => start());
  document.addEventListener('visibilitychange', () => {
    if (document.hidden) stop();
    else start();
  });

  let resizeTimer = null;
  window.addEventListener('resize', () => {
    window.clearTimeout(resizeTimer);
    resizeTimer = window.setTimeout(lockHeight, 200);
  });

  // Measure once the webfonts are in and the entrance animation has finished,
  // so neither is disturbed.
  const scheduleLock = () => window.setTimeout(lockHeight, 1600);
  if (document.fonts && document.fonts.ready) {
    document.fonts.ready.then(scheduleLock);
  } else {
    scheduleLock();
  }

  start();
}

/* --- Document pages: highlight the section you are reading ------------------ */

function initTableOfContents() {
  const links = Array.from(document.querySelectorAll('.toc a'));
  if (!links.length || !('IntersectionObserver' in window)) return;

  const sections = links
    .map((link) => document.querySelector(link.getAttribute('href')))
    .filter(Boolean);

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting) return;
        links.forEach((link) => {
          link.classList.toggle('is-current', link.getAttribute('href') === `#${entry.target.id}`);
        });
      });
    },
    { rootMargin: '-20% 0px -70% 0px' }
  );

  sections.forEach((section) => observer.observe(section));
}

/* --- Footer year ------------------------------------------------------------ */

function initYear() {
  const el = document.querySelector('[data-year]');
  if (el) el.textContent = String(new Date().getFullYear());
}

initTheme();
initHeader();
initReveals();
initFindCard();
initTableOfContents();
initYear();
