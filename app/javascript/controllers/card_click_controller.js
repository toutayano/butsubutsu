import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.querySelectorAll(".trade-card").forEach((card) => {
      card.addEventListener("click", (e) => {
        if (!e.target.closest(".profile-icon") && !e.target.closest(".like-button")) {
          window.location.href = card.dataset.href;
        }
      });
    });
  }
}