import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="highlight"
export default class extends Controller {
  static values = { tag: String } 

  connect() {
    // Converte o nome da tag para minúsculas para comparação insensível
    const tagNameLower = this.tagValue.toLowerCase(); 
    if (tagNameLower === 'popular' || tagNameLower === 'destaque') {
      this.element.closest('.film-card')?.classList.add('highlight');
    }
  }
}