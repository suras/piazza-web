import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="messages"
export default class extends Controller {

  static targets = ["message"]
  static values = { recipient: String }
  static classes = ["sender"]

  connect() {
    //  // Access the message container element using the reference
    //  const messageContainer = this.element.querySelector('[data-messages-container]');

    //  if (messageContainer) {
    //    // Execute scrolling after slight delay to allow DOM updates (optional)
    //    setTimeout(() => {
    //     console.log("Timeout done for scrolling")
    //      messageContainer.scrollIntoView({ behavior: "smooth" });
    //    }, 100);
    //  }
    this.scrollToBottom()
    this.element.addEventListener("turbo:before-stream-render", this.scrollToBottom.bind(this))
   }

   disconnect() {
    this.element.removeEventListener("turbo:before-stream-render", this.scrollToBottom.bind(this))
  }
  



  messageTargetConnected(target) {
    console.log("messageTargetConnected")
    // this.scrollToBottom()
    if (target.dataset.from == this.recipientValue) {
      target.classList.add(...this.senderClasses)
    }
  }

  // When a target becomes connected, Stimulus calls its
  //  controller’s [name]TargetConnected() method, passing 
  //  the target element as a parameter. The [name]TargetConnected() 
  // lifecycle callbacks will fire before the controller’s connect() callback.

//  scrollToBottom() {
//   console.log("scrollToBottom called");
//   requestAnimationFrame(() => {
//     console.log("Scroll height:", this.element.scrollHeight);
//     console.log("Client height:", this.element.clientHeight);
//     console.log("Scroll top before:", this.element.scrollTop);
//     this.element.scrollTop = this.element.scrollHeight;
//     console.log("Scroll top after:", this.element.scrollTop);
//   });
//}

scrollToBottom() {
  // Delay scrolling to allow DOM to finish rendering
  setTimeout(() => {
    console.log("Scroll height:", this.element.scrollHeight);
    console.log("Client height:", this.element.clientHeight);
    console.log("Scroll top before:", this.element.scrollTop);
    // this.element.scrollTop = this.element.scrollHeight;
    window.scrollTo(0, document.body.scrollHeight);
    console.log("Scroll top after:", this.element.scrollTop);
  }, 100); // You can adjust the timeout if needed
}

}
