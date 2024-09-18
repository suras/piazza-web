import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="messages"
export default class extends Controller {
  connect() {
  }

  static targets = ["message"]
  static values = { recipient: String }
  static classes = ["sender"]

  messageTargetConnected(target) {
    this.scrollToBottom()
    if (target.dataset.from == this.recipientValue) {
      target.classList.add(...this.senderClasses)
    }
  }

  // When a target becomes connected, Stimulus calls its
  //  controller’s [name]TargetConnected() method, passing 
  //  the target element as a parameter. The [name]TargetConnected() 
  // lifecycle callbacks will fire before the controller’s connect() callback.

  scrollToBottom(){
    this.element.scrollTop = this.element.scrollHeight
  }
}
