import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="back-to-top"
export default class extends Controller {
  connect() {
    this.toggleVisibility = this.toggleVisibility.bind(this); // Garante o 'this' correto no listener
    this.toggleVisibility(); 
    window.addEventListener('scroll', this.toggleVisibility);
  }

  disconnect() {
    window.removeEventListener('scroll', this.toggleVisibility);
  }

  toggleVisibility() {
    if (window.scrollY > 300) {
      this.element.style.display = 'block';
    } else {
      this.element.style.display = 'none';
    }
  }

  scrollToTop(event) {
    event.preventDefault();
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }
}