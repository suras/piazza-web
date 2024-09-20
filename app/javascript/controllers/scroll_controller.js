import { Controller } from "stimulus";

export default class extends Controller {
  connect() {
    this.scrollToBottom();
  }

  scrollToBottom() {
    const container = this.element;
    container.scrollTop = container.scrollHeight;
  }
}