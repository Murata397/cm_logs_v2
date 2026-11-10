import { Controller } from "@hotwired/stimulus"

// ダーク／ライトの切り替え
export default class extends Controller {
  static targets = ["label"]

  connect() {
    this.update()
  }

  toggle() {
    const root = document.documentElement
    const next = root.dataset.theme === "dark" ? "light" : "dark"
    root.dataset.theme = next
    try { localStorage.setItem("theme", next) } catch (e) {}
    this.update()
  }

  update() {
    const isDark = document.documentElement.dataset.theme === "dark"
    this.element.setAttribute("aria-pressed", String(isDark))
    if (this.hasLabelTarget) {
      this.labelTarget.textContent = isDark ? "ライトモード" : "ダークモード"
    }
  }
}