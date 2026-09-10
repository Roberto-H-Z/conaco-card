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

/* Conserva el punto exacto del directorio al abrir una ficha desde una tarjeta. */
(function rememberAffiliateOrigin() {
    document.querySelectorAll('[data-affiliate-link]').forEach((link) => {
        link.addEventListener('click', (event) => {
            if (event.defaultPrevented || event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return;
            sessionStorage.setItem('cp_profile_return_origin', link.dataset.affiliateSource || '');
        });
    });
})();

(function initPromotionNavigation() {
    const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    if (reduceMotion || !('startViewTransition' in document)) return;

    document.querySelectorAll('[data-promotion-link]').forEach((link) => {
        link.addEventListener('click', (event) => {
            if (event.defaultPrevented || event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return;
            const id = link.dataset.promotionId;
            const card = link.querySelector('.cp-promo-card') || link;
            if (/^[1-9][0-9]*$/.test(id || '')) card.style.viewTransitionName = `cp-promocion-${id}`;
            link.classList.add('is-navigating');
        });
    });

    window.addEventListener('pageshow', () => {
        document.querySelectorAll('[data-promotion-link].is-navigating').forEach((link) => link.classList.remove('is-navigating'));
    });
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

    const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    if (reduceMotion || !('IntersectionObserver' in window)) {
        elements.forEach(el => el.classList.add('visible'));
        return;
    }

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


/* ── 6. Carrusel continuo de promociones ───────────────────────────────── */
(function initPromoCarousel() {
    const viewport = document.querySelector('[data-carousel-viewport]');
    const track = document.querySelector('[data-carousel-track]');
    const status = document.querySelector('[data-carousel-status]');
    const originals = track ? Array.from(track.querySelectorAll('[data-carousel-item]')) : [];

    if (!viewport || !track || !originals.length) return;

    const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)');
    const baseSpeed = 30;
    const hoverSpeed = 8;
    let loopWidth = 0;
    let position = 0;
    let velocity = 0;
    let currentIndex = 0;
    let lastTime = 0;
    let frame = 0;
    let isHovering = false;
    let isDragging = false;
    let isFocused = false;
    let dragStartX = 0;
    let dragStartPosition = 0;
    let controlAnimation = null;
    let resizeFrame = 0;
    let wheelResumeTimer = 0;
    let isWheelInteracting = false;

    originals.forEach((item, index) => {
        item.dataset.carouselOriginalIndex = String(index);
    });

    function normalize(value) {
        if (!loopWidth) return 0;
        return ((value % loopWidth) + loopWidth) % loopWidth;
    }

    function setStatus(index = currentIndex) {
        const nextIndex = ((index % originals.length) + originals.length) % originals.length;
        if (nextIndex === currentIndex) return;

        currentIndex = nextIndex;
        if (status) {
            status.textContent = `${String(currentIndex + 1).padStart(2, '0')} / ${String(originals.length).padStart(2, '0')}`;
        }
    }

    function render() {
        track.style.transform = `translate3d(${-position.toFixed(2)}px, 0, 0)`;
    }

    function getStep() {
        return loopWidth ? loopWidth / originals.length : 0;
    }

    function syncCurrentIndex() {
        const step = getStep();
        if (!step) return;
        setStatus(Math.floor((position + step * 0.42) / step));
    }

    function cloneItem(item) {
        const clone = item.cloneNode(true);
        clone.dataset.carouselClone = 'true';
        clone.setAttribute('aria-hidden', 'true');
        clone.removeAttribute('aria-label');
        clone.querySelectorAll('[id]').forEach(element => element.removeAttribute('id'));
        clone.querySelectorAll('img').forEach(image => image.setAttribute('alt', ''));
        clone.querySelectorAll('a, button, input, select, textarea, [tabindex]')
            .forEach(element => element.setAttribute('tabindex', '-1'));
        return clone;
    }

    function rebuild() {
        track.querySelectorAll('[data-carousel-clone]').forEach(clone => clone.remove());
        track.style.transform = 'translate3d(0, 0, 0)';

        const gap = parseFloat(getComputedStyle(track).gap) || 0;
        const first = originals[0];
        const last = originals[originals.length - 1];
        const singleSetWidth = last.offsetLeft - first.offsetLeft + last.offsetWidth + gap;
        const neededSets = Math.max(2, Math.ceil((viewport.clientWidth * 2 + 160) / singleSetWidth) + 1);

        for (let set = 1; set < neededSets; set += 1) {
            originals.forEach(item => track.appendChild(cloneItem(item)));
        }

        const firstClone = track.querySelector('[data-carousel-clone]');
        loopWidth = firstClone ? firstClone.offsetLeft - first.offsetLeft : singleSetWidth;
        position = normalize(currentIndex * getStep());
        render();
    }

    function autoPaused() {
        return reduceMotion.matches || isFocused || isWheelInteracting || document.hidden;
    }

    function move(direction) {
        const step = getStep();
        if (!step) return;

        controlAnimation = {
            start: position,
            distance: direction * step,
            startedAt: performance.now(),
            duration: reduceMotion.matches ? 0 : 480
        };
        setStatus(currentIndex + direction);
    }

    function tick(timestamp) {
        const delta = Math.min(64, timestamp - (lastTime || timestamp));
        lastTime = timestamp;

        if (!isDragging && loopWidth) {
            if (controlAnimation) {
                const elapsed = timestamp - controlAnimation.startedAt;
                const progress = controlAnimation.duration === 0
                    ? 1
                    : Math.min(1, elapsed / controlAnimation.duration);
                const eased = 1 - Math.pow(1 - progress, 3);
                position = normalize(controlAnimation.start + controlAnimation.distance * eased);

                if (progress === 1) {
                    controlAnimation = null;
                    syncCurrentIndex();
                }
            } else {
                const targetSpeed = autoPaused() ? 0 : (isHovering ? hoverSpeed : baseSpeed);
                const easing = autoPaused() ? 1 : Math.min(1, delta / 260);
                velocity += (targetSpeed - velocity) * easing;
                position = normalize(position + velocity * (delta / 1000));
                syncCurrentIndex();
            }
            render();
        }

        frame = requestAnimationFrame(tick);
    }

    viewport.addEventListener('mouseenter', () => {
        isHovering = true;
    });

    viewport.addEventListener('mouseleave', () => {
        isHovering = false;
    });

    viewport.addEventListener('focusin', () => {
        isFocused = true;
        velocity = 0;
    });

    viewport.addEventListener('focusout', () => {
        window.setTimeout(() => {
            isFocused = viewport.contains(document.activeElement);
        }, 0);
    });

    viewport.addEventListener('pointerdown', event => {
        if (event.button !== 0 || event.target.closest('a, button, input, select, textarea')) return;

        isDragging = true;
        dragStartX = event.clientX;
        dragStartPosition = position;
        velocity = 0;
        controlAnimation = null;
        viewport.classList.add('is-dragging');
        viewport.setPointerCapture(event.pointerId);
    });

    viewport.addEventListener('pointermove', event => {
        if (!isDragging) return;
        position = normalize(dragStartPosition - (event.clientX - dragStartX));
        render();
    });

    function stopDrag(event) {
        if (!isDragging) return;
        isDragging = false;
        viewport.classList.remove('is-dragging');
        if (viewport.hasPointerCapture(event.pointerId)) viewport.releasePointerCapture(event.pointerId);
        syncCurrentIndex();
    }

    viewport.addEventListener('pointerup', stopDrag);
    viewport.addEventListener('pointercancel', stopDrag);

    viewport.addEventListener('wheel', event => {
        if (event.ctrlKey || !loopWidth) return;

        const primaryDelta = Math.abs(event.deltaX) > Math.abs(event.deltaY)
            ? event.deltaX
            : event.deltaY;
        if (primaryDelta === 0) return;

        event.preventDefault();
        controlAnimation = null;
        velocity = 0;
        isWheelInteracting = true;

        const unit = event.deltaMode === WheelEvent.DOM_DELTA_LINE ? 16 : 1;
        const distance = Math.max(-180, Math.min(180, primaryDelta * unit));
        position = normalize(position + distance);
        syncCurrentIndex();
        render();

        window.clearTimeout(wheelResumeTimer);
        wheelResumeTimer = window.setTimeout(() => {
            isWheelInteracting = false;
            velocity = 0;
        }, 1000);
    }, { passive: false });

    viewport.addEventListener('keydown', event => {
        if (event.key === 'ArrowLeft' || event.key === 'ArrowRight') {
            event.preventDefault();
            move(event.key === 'ArrowRight' ? 1 : -1);
        }

    });

    reduceMotion.addEventListener('change', () => {
        velocity = 0;
    });

    window.addEventListener('resize', () => {
        cancelAnimationFrame(resizeFrame);
        resizeFrame = requestAnimationFrame(rebuild);
    }, { passive: true });

    rebuild();
    frame = requestAnimationFrame(tick);
})();


/* ── 7. Luz contextual en tarjetas de empresas ─────────────────────────── */
(function initCardSpotlight() {
    const cards = document.querySelectorAll('[data-spotlight-card]');
    const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    if (!cards.length || reduceMotion || !window.matchMedia('(hover: hover)').matches) return;

    cards.forEach(card => {
        let frame = 0;

        card.addEventListener('pointermove', event => {
            cancelAnimationFrame(frame);
            frame = requestAnimationFrame(() => {
                const rect = card.getBoundingClientRect();
                const x = ((event.clientX - rect.left) / rect.width) * 100;
                const y = ((event.clientY - rect.top) / rect.height) * 100;
                card.style.setProperty('--spot-x', `${x.toFixed(1)}%`);
                card.style.setProperty('--spot-y', `${y.toFixed(1)}%`);
            });
        }, { passive: true });

        card.addEventListener('pointerleave', () => {
            card.style.setProperty('--spot-x', '50%');
            card.style.setProperty('--spot-y', '50%');
        }, { passive: true });
    });
})();


/* ── 8. Smooth scroll para links de ancla ────────────────────────────────── */
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


/* El buscador usa un formulario GET nativo para conservar URL e historial. */


/* ── 10. ScrollSpy para Navegación ──────────────────────────────────────── */
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
