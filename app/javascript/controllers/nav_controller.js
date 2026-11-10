import { Controller } from "@hotwired/stimulus"

// ハンバーガーメニューの開閉
export default class extends Controller {
  static targets = ["button", "menu"]

  toggle() {
    const isOpen = this.buttonTarget.getAttribute("aria-expanded") === "true"
    this.buttonTarget.setAttribute("aria-expanded", String(!isOpen))
    this.buttonTarget.setAttribute("aria-label", isOpen ? "メニューを開く" : "メニューを閉じる")
    this.menuTarget.classList.toggle("is-open", !isOpen)
  }
}