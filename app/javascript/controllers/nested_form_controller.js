import { Controller } from "@hotwired/stimulus"

// 「＋ 追加」「削除」で入力欄を増やしたり減らしたりする
export default class extends Controller {
  static targets = ["template", "list"]

  connect() {
    this.renumber()
  }

  add() {
    // テンプレートの NEW_RECORD を、重ならない番号に置き換えて追加する
    const html = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, Date.now().toString())
    this.listTarget.insertAdjacentHTML("beforeend", html)
    this.renumber()
  }

  remove(event) {
    const item = event.target.closest(".js-nested-item")

    if (item.dataset.newRecord === "true") {
      // まだ保存していない欄は、そのまま消す
      item.remove()
    } else {
      // 保存済みの欄は、隠して「削除する」印をつける
      item.hidden = true
      item.querySelector("input[name*='_destroy']").value = "1"
    }
    this.renumber()
  }

  // 見えている欄に、上から 1, 2, 3... と番号をつけ直す
  renumber() {
    const items = [...this.listTarget.querySelectorAll(".js-nested-item")].filter((item) => !item.hidden)
    items.forEach((item, index) => {
      const position = item.querySelector(".js-position")
      if (position) position.value = index + 1
      const number = item.querySelector(".js-number")
      if (number) number.textContent = index + 1
    })
  }
}