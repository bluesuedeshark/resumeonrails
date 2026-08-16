import { Controller } from "@hotwired/stimulus"

// Native SVG <title> tooltips don't fire on tap at all on mobile, and on
// desktop they're an unstyled, delayed browser tooltip that's easy to miss.
// This gives every bar a visible readout on both hover and tap.
export default class extends Controller {
  static targets = ["readout"]

  show(event) {
    const { date, avg, worst } = event.params
    this.readoutTarget.textContent = `${date}: ${avg} min avg, ${worst} min worst`
  }
}
