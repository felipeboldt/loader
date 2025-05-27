document.addEventListener('DOMContentLoaded', function() {
    // Header con scroll
    const header = document.querySelector('header');
    if (header) {
        window.addEventListener('scroll', () => {
            if (window.scrollY > 50) { 
                header.classList.add('scrolled');
            } else {
                header.classList.remove('scrolled');
            }
        });
    }

    // Menú Hamburguesa
    const menuToggle = document.querySelector('.menu-toggle');
    const navLinks = document.querySelector('.nav-links');
    if (menuToggle && navLinks) {
        menuToggle.addEventListener('click', () => {
            navLinks.classList.toggle('active');
            if (navLinks.classList.contains('active')) {
                menuToggle.setAttribute('aria-label', 'Cerrar menú');
                menuToggle.textContent = '✕'; 
            } else {
                menuToggle.setAttribute('aria-label', 'Abrir menú');
                menuToggle.textContent = '☰'; 
            }
        });
    }

    // Cerrar menú al hacer clic en un enlace
    if (navLinks) {
        navLinks.querySelectorAll('a').forEach(link => {
            link.addEventListener('click', () => {
                if (navLinks.classList.contains('active')) {
                    navLinks.classList.remove('active');
                    if (menuToggle) { 
                        menuToggle.setAttribute('aria-label', 'Abrir menú');
                        menuToggle.textContent = '☰';
                    }
                }
            });
        });
    }

    // Actualizar año en el footer
    const currentYearSpan = document.getElementById('current-year');
    if (currentYearSpan) {
        currentYearSpan.textContent = new Date().getFullYear();
    }

    // Eliminada la lógica del formulario de contacto anterior
    // const contactForm = document.getElementById('contact-form');
    // if (contactForm) {
    //     contactForm.addEventListener('submit', function(e) {
    //         e.preventDefault(); 
    //         alert('Formulario enviado (simulación). Necesitas configurar un backend o servicio para procesarlo.');
    //         this.reset(); 
    //     });
    // }

    // Lightbox para Casos de Uso
    const lightboxModal = document.getElementById('lightbox-modal');
    const lightboxImg = document.getElementById('lightbox-img');
    const lightboxCaption = document.getElementById('lightbox-caption');
    const useCaseImages = document.querySelectorAll('.use-case-image');
    const lightboxClose = document.querySelector('.lightbox-close');

    useCaseImages.forEach(image => {
        image.addEventListener('click', function() {
            if (lightboxModal && lightboxImg && lightboxCaption) {
                lightboxModal.style.display = "block";
                lightboxImg.src = this.src;
                lightboxCaption.innerHTML = this.alt;
                document.body.style.overflow = 'hidden';
            }
        });
    });

    function closeLightbox() {
        if (lightboxModal) {
            lightboxModal.style.display = "none";
            document.body.style.overflow = 'auto';
        }
    }

    if (lightboxClose) {
        lightboxClose.addEventListener('click', closeLightbox);
    }
    if (lightboxModal) {
        lightboxModal.addEventListener('click', function(event) {
            if (event.target === lightboxModal) {
                closeLightbox();
            }
        });
    }
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape' && lightboxModal && lightboxModal.style.display === "block") {
            closeLightbox();
        }
    });
});