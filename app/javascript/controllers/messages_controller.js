import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="messages"
export default class extends Controller {
  connect() {
  }

  static targets = ["message"]

  messageTargetConnected(target) {
    this.scrollToBottom()
  }

  scrollToBottom(){
    this.element.scrollTop = this.element.scrollHeight
  }
}
