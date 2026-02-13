import { Controller } from "@hotwired/stimulus"

// Automatically dismisses flash messages after 3 seconds
export default class extends Controller {
  connect() {
    this.timeout = setTimeout(() => {
      this.element.remove()
    }, 3000)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}
