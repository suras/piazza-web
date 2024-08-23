import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tags"
export default class extends Controller {
  connect() {
  }

  static targets = ["template", "container", "input"]

  addTag() {
    if(this.inputTarget.value.length > 0){
      var templateHtml = this.templateTarget.innerHTML

      templateHtml = templateHtml.replace(/{value}/g, this.inputTarget.value)

      this.inputTarget.value = ""

      this.containerTarget.insertAdjacentHTML("beforeend", templateHtml)
    }
  }
}
