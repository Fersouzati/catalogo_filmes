import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="fade-in"
export default class extends Controller {
  static targets = [ "item" ] 

  connect() {
    this.itemTargets.forEach((item, index) => {
      item.style.opacity = "0";
      item.style.transform = "translateY(20px)"; 
      setTimeout(() => {
        item.style.transition = "opacity 0.6s ease-out, transform 0.6s ease-out"; 
        item.style.opacity = "1";
        item.style.transform = "translateY(0)";
      }, index * 100); 
    });
  }
}