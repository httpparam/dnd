import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "input"]

  connect() {
    this.scrollToBottom()
  }

  clear(event) {
    if (event.detail.success && this.hasInputTarget) {
      this.inputTarget.value = ""
      this.scrollToBottom()
    }
  }

  scrollToBottom() {
    if (!this.hasListTarget) return
    this.listTarget.scrollTop = this.listTarget.scrollHeight
  }
}
