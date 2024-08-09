import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tags"
export default class extends Controller {
  connect() {
  }

  static targets = ["template", "container", "input"]

  addTag() {
    var templateHtml = this.templateTarget.innerHTML

    templateHtml = templateHtml.replace(/{value}/g, this.inputTarget.value)

    this.inputTarget.value = ""

    this.containerTarget.insertAdjacentHTML("beforeend", templateHtml)
  }
}
