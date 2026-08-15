import { Controller } from "@hotwired/stimulus"

// Combines the three carline options and projects an outcome. Option C's
// effect is a real number computed server-side (bus-ready families / avg
// cars in line); A and B are disclosed estimates layered on that baseline —
// there's no controlled measurement for those, and the UI says so.
export default class extends Controller {
  static targets = ["optionA", "optionB", "optionC", "wait", "reduction", "cars", "effort", "timeline", "note"]
  static values = { baselineWait: Number, busReady: Number, effectC: Number }

  EFFECT_A = 0.15
  EFFECT_B = 0.20
  EFFORT_LABELS = { 1: "Low-medium", 2: "Medium", 3: "High" }
  TIMELINE_LABELS = { 1: "Weeks", 2: "Weeks", 3: "A semester" }

  connect() {
    this.recalculate()
  }

  recalculate() {
    const options = [
      { checked: this.optionATarget.checked, effect: this.EFFECT_A, effort: 1, carsRemoved: 0 },
      { checked: this.optionBTarget.checked, effect: this.EFFECT_B, effort: 2, carsRemoved: 0 },
      { checked: this.optionCTarget.checked, effect: this.effectCValue, effort: 3, carsRemoved: this.busReadyValue }
    ]
    const selected = options.filter((o) => o.checked)

    if (selected.length === 0) {
      this.waitTarget.textContent = `${this.baselineWaitValue} min`
      this.reductionTarget.textContent = "baseline — no changes selected"
      this.carsTarget.textContent = "0"
      this.effortTarget.textContent = "—"
      this.timelineTarget.textContent = "—"
      this.noteTarget.textContent = ""
      return
    }

    const remaining = selected.reduce((acc, o) => acc * (1 - o.effect), 1)
    const projectedWait = this.baselineWaitValue * remaining
    const reductionPct = Math.round((1 - remaining) * 100)
    const carsRemoved = selected.reduce((sum, o) => sum + o.carsRemoved, 0)
    const maxEffort = Math.max(...selected.map((o) => o.effort))

    this.waitTarget.textContent = `${projectedWait.toFixed(1)} min`
    this.reductionTarget.textContent = `${reductionPct}% below the ${this.baselineWaitValue} min baseline`
    this.carsTarget.textContent = carsRemoved
    this.effortTarget.textContent = this.EFFORT_LABELS[maxEffort]
    this.timelineTarget.textContent = this.TIMELINE_LABELS[maxEffort]

    const usesEstimate = this.optionATarget.checked || this.optionBTarget.checked
    this.noteTarget.textContent = usesEstimate
      ? "Wait-time reduction includes disclosed estimates (A/B). Cars-removed is the one measured figure (C)."
      : "Cars-removed and wait-time reduction both derive from the real bus-ready count."
  }
}
