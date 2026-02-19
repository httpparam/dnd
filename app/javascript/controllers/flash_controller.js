import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { timeout: Number }

  connect() {
    this.dismissAfter = window.setTimeout(() => this.dismiss(), this.timeoutValue || 4000)
    this.handleBeforeCache = this.dismiss.bind(this)
    document.addEventListener("turbo:before-cache", this.handleBeforeCache)
  }

  disconnect() {
    window.clearTimeout(this.dismissAfter)
    document.removeEventListener("turbo:before-cache", this.handleBeforeCache)
  }

  dismiss() {
    this.element.remove()
  }
}
