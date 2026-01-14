import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { datetime: String };

  connect() {
    const seconds = this.calculateDiffInseconds();

    this.element.textContent = `${this.formatTime(this.calculateDiffInseconds())}`;
  }

  update() {
    const seconds = this.calculateDiffInseconds();
    this.element.textContent = `${this.formatTime(this.calculateDiffInseconds())}`;
  }

  calculateDiffInseconds() {
    const date = new Date(this.datetimeValue).getTime();
    const now = Date.now();

    return Math.floor((now - date) / 1000);
  }

  formatTime(seconds) {
    if (seconds < 60) {
      return "just now";
    }

    const minutes = Math.floor(seconds / 60);
    if (minutes < 60) {
      return `${minutes} min ago`;
    }

    const hours = Math.floor(minutes / 60);
    if (hours < 24) {
      return `${hours} ${hours === 1 ? "h" : "h"} ago`;
    }

    const days = Math.floor(hours / 24);
    return `${days} ${days === 1 ? "day" : "days"} ago`;
  }
}
