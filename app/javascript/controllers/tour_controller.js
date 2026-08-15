import { Controller } from "@hotwired/stimulus"

// Landing fork: "walk me through it" vs "I'll explore myself." The tour
// itself is just a handful of slides with real links out — clicking any
// link exits the tour by navigating away, no separate exit handling needed.
export default class extends Controller {
  static targets = ["fork", "tour", "slide", "prevBtn", "nextBtn", "dot"]

  connect() {
    this.step = 0
    this.boundKeydown = this.handleKeydown.bind(this)
    this.showSlide()
  }

  disconnect() {
    document.removeEventListener("keydown", this.boundKeydown)
  }

  startTour() {
    this.forkTarget.classList.add("hidden")
    this.tourTarget.classList.remove("hidden")
    document.addEventListener("keydown", this.boundKeydown)
  }

  skip() {
    this.forkTarget.classList.add("hidden")
  }

  exit() {
    this.tourTarget.classList.add("hidden")
    document.removeEventListener("keydown", this.boundKeydown)
  }

  next() {
    if (this.step < this.slideTargets.length - 1) {
      this.step++
      this.showSlide()
    } else {
      this.exit()
    }
  }

  prev() {
    if (this.step > 0) {
      this.step--
      this.showSlide()
    }
  }

  handleKeydown(event) {
    if (event.key === "ArrowRight") this.next()
    if (event.key === "ArrowLeft") this.prev()
    if (event.key === "Escape") this.exit()
  }

  showSlide() {
    this.slideTargets.forEach((el, i) => el.classList.toggle("hidden", i !== this.step))
    this.prevBtnTarget.classList.toggle("invisible", this.step === 0)
    this.nextBtnTarget.textContent = this.step === this.slideTargets.length - 1 ? "Done" : "Next →"
    this.dotTargets.forEach((dot, i) => {
      dot.classList.toggle("bg-indigo-600", i === this.step)
      dot.classList.toggle("bg-slate-200", i !== this.step)
    })
  }
}
