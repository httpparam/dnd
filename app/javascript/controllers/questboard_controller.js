import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "tab", "loading", "hostForm"]
  static values = { active: String }

  connect() {
    this.switchTo(this.activeValue || "campaigns")

    if (this.hasLoadingTarget) {
      setTimeout(() => {
        this.loadingTarget.remove()
      }, 600)
    }
  }

  switch(event) {
    this.switchTo(event.params.view)
  }

  switchTo(view) {
    this.panelTargets.forEach((panel) => {
      const isActive = panel.dataset.questboardPanel === view
      panel.classList.toggle("hidden", !isActive)
    })

    this.tabTargets.forEach((tab) => {
      const isActive = tab.dataset.questboardViewParam === view
      tab.classList.toggle("bg-indigo-600/20", isActive)
      tab.classList.toggle("text-indigo-400", isActive)
      tab.classList.toggle("border-indigo-500", isActive)
      tab.classList.toggle("hover:bg-slate-800", !isActive)
      tab.classList.toggle("text-slate-500", !isActive)
      tab.classList.toggle("border-transparent", !isActive)
      tab.classList.toggle("hover:text-slate-300", !isActive)
    })
  }

  toggleHost() {
    if (!this.hasHostFormTarget) return
    this.hostFormTarget.classList.toggle("hidden")
  }
}
