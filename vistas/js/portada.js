/**
 * CANACO Card — JS del Portal Público (portada.js)
 * Funcionalidades:
 *   - Navbar sticky con glassmorphism
 *   - Menú hamburguesa móvil
 *   - Animación count-up en los contadores del Hero
 *   - Fade-in de secciones con Intersection Observer
 *   - Efecto Ken Burns en el hero al carga
 */
'use strict';

/* ── 1. Navbar: glassmorphism en scroll ─────────────────────────────────── */
(function initNavScroll() {
    const nav = document.getElementById('cpNav');
    if (!nav) return;

    function updateNav() {
        if (window.scrollY > 40) {
            nav.classList.add('scrolled');
        } else {
            nav.classList.remove('scrolled');
        }
    }

    window.addEventListener('scroll', updateNav, { passive: true });
    updateNav(); // Estado inicial
})();


/* ── 2. Menú hamburguesa ────────────────────────────────────────────────── */
(function initMobileNav() {
    const hamburger = document.getElementById('cpNavHamburger');
    const mobileNav = document.getElementById('cpNavMobile');
    const closeBtn  = document.getElementById('cpNavMobileClose');

    if (!hamburger || !mobileNav) return;

    function openMobileNav() {
        mobileNav.classList.add('open');
        hamburger.setAttribute('aria-expanded', 'true');
        document.body.style.overflow = 'hidden';
    }

    function closeMobileNav() {
        mobileNav.classList.remove('open');
        hamburger.setAttribute('aria-expanded', 'false');
        document.body.style.overflow = '';
    }

    // Exponer globalmente para los onclick inline
    window.closeMobileNav = closeMobileNav;

    hamburger.addEventListener('click', openMobileNav);
    if (closeBtn) closeBtn.addEventListener('click', closeMobileNav);

    // Cerrar con ESC
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && mobileNav.classList.contains('open')) {
            closeMobileNav();
        }
    });
})();


/* ── 3. Hero Ken Burns effect ───────────────────────────────────────────── */
(function initHeroEffect() {
    const hero = document.querySelector('.cp-hero');
    if (!hero) return;
    // Activar animación suave de zoom después de que cargue la imagen
    requestAnimationFrame(() => {
        setTimeout(() => hero.classList.add('loaded'), 100);
    });
})();


/* ── 4. Count-up animation en contadores del Hero ───────────────────────── */
(function initCountUp() {
    const counters = document.querySelectorAll('.cp-hero-stat-num[data-count]');
    if (!counters.length) return;

    const duration = 1800; // ms
    const easeOut  = (t) => 1 - Math.pow(1 - t, 3);

    function animateCounter(el) {
        const target = parseInt(el.dataset.count, 10);
        if (isNaN(target) || target === 0) return;

        const start = performance.now();

        function tick(now) {
            const elapsed  = now - start;
            const progress = Math.min(elapsed / duration, 1);
            const value    = Math.round(easeOut(progress) * target);

            el.textContent = value.toLocaleString('es-MX');

            if (progress < 1) {
                requestAnimationFrame(tick);
            } else {
                el.textContent = target.toLocaleString('es-MX');
            }
        }

        requestAnimationFrame(tick);
    }

    // Usar IntersectionObserver para activar cuando el hero sea visible
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                counters.forEach(animateCounter);
                observer.disconnect();
            }
        });
    }, { threshold: 0.4 });

    const heroStats = document.querySelector('.cp-hero-stats');
    if (heroStats) observer.observe(heroStats);
})();


/* ── 5. Fade-in de secciones con Intersection Observer ─────────────────── */
(function initFadeIn() {
    const elements = document.querySelectorAll('.cp-fade-in');
    if (!elements.length) return;

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
                observer.unobserve(entry.target);
            }
        });
    }, {
        threshold: 0.12,
        rootMargin: '0px 0px -40px 0px'
    });

    elements.forEach(el => observer.observe(el));
})();


/* ── 6. Smooth scroll para links de ancla ────────────────────────────────── */
(function initSmoothScroll() {
    document.querySelectorAll('a[href^="#"]').forEach(link => {
        link.addEventListener('click', function(e) {
            const href = this.getAttribute('href');
            if (href === '#') return;

            const target = document.querySelector(href);
            if (!target) return;

            e.preventDefault();
            const navH = parseInt(getComputedStyle(document.documentElement)
                .getPropertyValue('--cp-nav-h')) || 72;

            window.scrollTo({
                top: target.getBoundingClientRect().top + window.scrollY - navH,
                behavior: 'smooth'
            });
        });
    });
})();


/* ── 7. Buscador del Hero (placeholder funcional) ─────────────────────── */
(function initHeroSearch() {
    const btn   = document.getElementById('cpHeroSearchBtn');
    const input = document.getElementById('cpHeroSearch');
    if (!btn || !input) return;

    function doSearch() {
        const q = input.value.trim();
        if (!q) {
            input.focus();
            return;
        }
        // TODO: implementar búsqueda real — por ahora scroll a directorio
        const dir = document.getElementById('empresas');
        if (dir) {
            dir.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    }

    btn.addEventListener('click', doSearch);
    input.addEventListener('keydown', function(e) {
        if (e.key === 'Enter') doSearch();
    });
})();


/* ── 8. ScrollSpy para Navegación ───────────────────────────────────────── */
(function initScrollSpy() {
    const sections = document.querySelectorAll('section[id], footer[id]');
    const navLinks = document.querySelectorAll('.cp-nav-links a');
    
    if (!navLinks.length || !sections.length) return;

    function onScroll() {
        let current = 'inicio'; 
        const navHeight = 90; // offset de la barra de navegación
        
        // Comprobar si hemos llegado al final de la página
        const scrollPosition = window.innerHeight + window.scrollY;
        const documentHeight = Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight);
        
        if (scrollPosition >= documentHeight - 50) {
            // Si estamos al fondo, la sección activa es la última
            current = sections[sections.length - 1].getAttribute('id');
        } else {
            // Iterar de abajo hacia arriba para encontrar la sección visible más baja
            for (let i = sections.length - 1; i >= 0; i--) {
                const section = sections[i];
                const rect = section.getBoundingClientRect();
                
                // Si la parte superior de la sección cruzó nuestro umbral visual
                if (rect.top <= window.innerHeight / 2) {
                    current = section.getAttribute('id');
                    break;
                }
            }
        }

        // Remover clase activa de todos y asignarla al correcto
        navLinks.forEach(link => {
            link.classList.remove('active-nav-link');
            const href = link.getAttribute('href');
            
            if (current && href.endsWith('#' + current)) {
                link.classList.add('active-nav-link');
            } else if (current === 'inicio' && !href.includes('#')) {
                // Link de inicio
                link.classList.add('active-nav-link');
            }
        });
    }

    window.addEventListener('scroll', onScroll, { passive: true });
    setTimeout(onScroll, 100);
})();
