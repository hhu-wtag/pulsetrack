import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
    connect() {
        // 1. Wait 5 seconds
        setTimeout(() => {
            this.dismiss()
        }, 5000)
    }

    dismiss() {
        // 2. Add a Tailwind transition class for a smooth fade
        this.element.classList.add("transition-opacity", "duration-500", "opacity-0")

        // 3. Wait for the transition to finish, then remove from DOM
        setTimeout(() => {
            this.element.remove()
        }, 500)
    }
}