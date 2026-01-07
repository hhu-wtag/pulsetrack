import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("connected to heartbeat");

    if (this.timer) {
      return;
    }

    this.timer = setInterval(() => {
      window.dispatchEvent(new CustomEvent("tick"));
    }, 60000);
  }

  disconnect() {
    clearInterval(this.timer);
  }
}
