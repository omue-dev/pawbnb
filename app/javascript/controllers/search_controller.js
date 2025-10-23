// app/javascript/controllers/search_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]

  search() {
    const query = this.inputTarget.value
    fetch(`/hotels/search?query=${encodeURIComponent(query)}`)
      .then(response => response.text())
      .then(html => this.resultsTarget.innerHTML = html)
  }
}
