import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["title", "message", "formContainer", "modal"]

    connect() {
        this.modalTarget.addEventListener("close", this.clear)
    }

    open(event) {
        event.preventDefault()

        const params = event.params

        this.titleTarget.textContent = params.title || "Confirm"
        this.messageTarget.textContent = params.message || "Are you sure?"

        const form = document.createElement("form")
        form.method = "post"
        form.action = params.url

        const methodInput = document.createElement("input")
        methodInput.type = "hidden"
        methodInput.name = "_method"
        methodInput.value = "delete"

        const token = document.querySelector('meta[name="csrf-token"]').content
        const tokenInput = document.createElement("input")
        tokenInput.type = "hidden"
        tokenInput.name = "authenticity_token"
        tokenInput.value = token

        const submitButton = document.createElement("button")
        submitButton.type = "submit"
        submitButton.textContent = params.buttonText || "Delete"
        submitButton.className = "btn btn-error" // daisyUI styling

        form.appendChild(methodInput)
        form.appendChild(tokenInput)
        form.appendChild(submitButton)

        this.formContainerTarget.innerHTML = "" // Clear old form
        this.formContainerTarget.appendChild(form)

        this.modalTarget.showModal()
    }

    close() {
        this.modalTarget.close()
    }

    clear() {
        this.formContainerTarget.innerHTML = ""
    }
}