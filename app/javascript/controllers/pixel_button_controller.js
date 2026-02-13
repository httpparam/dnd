import { Controller } from "@hotwired/stimulus"

// Pixel-themed input field with uiverse-style animation
// Connects to parent input to sync values bi-directionally
export default class extends Controller {
  static targets = ["input"]

  connect() {
    // Focus the wrapped input when controller connects
    this.focusInput()
  }

  inputTarget.addEventListener('focus', () => {
    this.element.classList.add('uiverse-focused')
  })

  inputTarget.addEventListener('blur', () => {
    this.element.classList.remove('uiverse-focused')
  })
}

  focusInput() {
    this.inputTarget?.focus()
  }
}
