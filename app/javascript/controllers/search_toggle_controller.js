import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["bar"]

  toggle() {
    this.barTarget.classList.toggle("d-none")
  }
}
