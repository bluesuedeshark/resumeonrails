import { Controller } from "@hotwired/stimulus"

// A deliberately silly lane-dodging game: your car crawls toward the pickup
// spot, weave left/right to avoid obstacles, get to your kid before the
// timer runs out. Charming-and-working is the bar, not tight game feel.
export default class extends Controller {
  static targets = ["canvas", "status", "level", "startButton"]

  LANE_COUNT = 4
  OBSTACLE_KINDS = [
    { emoji: "🚙", label: "an SUV hogging two lanes" },
    { emoji: "📱", label: "the mom on her phone" },
    { emoji: "🚸", label: "the crossing guard waving everyone through" },
    { emoji: "🚲", label: "a kid weaving on a bike" },
    { emoji: "🐕", label: "a loose dog" }
  ]

  connect() {
    this.ctx = this.canvasTarget.getContext("2d")
    this.width = this.canvasTarget.width
    this.height = this.canvasTarget.height
    this.laneWidth = this.width / this.LANE_COUNT
    this.running = false
    this.level = 1
    this.boundKeydown = this.handleKeydown.bind(this)
    this.drawIdleFrame()
  }

  disconnect() {
    this.stopLoop()
    document.removeEventListener("keydown", this.boundKeydown)
  }

  start() {
    this.level = 1
    this.beginLevel()
  }

  nextLevel() {
    this.level += 1
    this.beginLevel()
  }

  retry() {
    this.beginLevel()
  }

  beginLevel() {
    this.playerLane = Math.floor(this.LANE_COUNT / 2)
    this.progress = 0 // 0 = still in line, 1 = reached the pickup spot
    this.speed = 0.09 + (this.level - 1) * 0.035
    this.spawnChance = 0.02 + (this.level - 1) * 0.008
    this.obstacles = []
    this.running = true
    this.statusTarget.textContent = ""
    this.levelTarget.textContent = `Level ${this.level}`
    document.addEventListener("keydown", this.boundKeydown)
    this.lastTime = performance.now()
    this.loop()
  }

  stopLoop() {
    this.running = false
    if (this.frame) cancelAnimationFrame(this.frame)
  }

  handleKeydown(event) {
    if (!this.running) return
    if (event.key === "ArrowLeft") this.moveLane(-1)
    if (event.key === "ArrowRight") this.moveLane(1)
  }

  moveLane(direction) {
    this.playerLane = Math.min(this.LANE_COUNT - 1, Math.max(0, this.playerLane + direction))
  }

  tapLeft() { if (this.running) this.moveLane(-1) }
  tapRight() { if (this.running) this.moveLane(1) }

  loop() {
    if (!this.running) return
    const now = performance.now()
    const dt = Math.min(now - this.lastTime, 50)
    this.lastTime = now

    this.update(dt)
    this.draw()

    this.frame = requestAnimationFrame(() => this.loop())
  }

  update(dt) {
    this.progress += (this.speed * dt) / 1000

    if (Math.random() < this.spawnChance) {
      const kind = this.OBSTACLE_KINDS[Math.floor(Math.random() * this.OBSTACLE_KINDS.length)]
      this.obstacles.push({
        lane: Math.floor(Math.random() * this.LANE_COUNT),
        y: -40,
        ...kind
      })
    }

    const fallSpeed = (0.25 + this.level * 0.05) * dt
    this.obstacles.forEach((o) => (o.y += fallSpeed))
    this.obstacles = this.obstacles.filter((o) => o.y < this.height + 40)

    const playerY = this.height - 70
    for (const o of this.obstacles) {
      if (o.lane === this.playerLane && Math.abs(o.y - playerY) < 30) {
        this.fail(o.label)
        return
      }
    }

    if (this.progress >= 1) {
      this.win()
    }
  }

  fail(reason) {
    this.running = false
    document.removeEventListener("keydown", this.boundKeydown)
    this.statusTarget.innerHTML = `🚗💥 Busted by ${reason}.<br>Guess you're still stuck in car line. Better luck at 2:45 tomorrow.`
  }

  win() {
    this.running = false
    document.removeEventListener("keydown", this.boundKeydown)
    this.statusTarget.innerHTML = `🎉 Your kid hopped in! You are now legally cleared to speed to Chick-fil-A.`
  }

  drawIdleFrame() {
    const ctx = this.ctx
    ctx.fillStyle = "#1e293b"
    ctx.fillRect(0, 0, this.width, this.height)
    ctx.fillStyle = "#94a3b8"
    ctx.font = "16px sans-serif"
    ctx.textAlign = "center"
    ctx.fillText("Press Start when you're ready to dodge.", this.width / 2, this.height / 2)
  }

  draw() {
    const ctx = this.ctx
    ctx.fillStyle = "#1e293b"
    ctx.fillRect(0, 0, this.width, this.height)

    // Lane dividers
    ctx.strokeStyle = "#334155"
    ctx.setLineDash([10, 10])
    for (let i = 1; i < this.LANE_COUNT; i++) {
      const x = i * this.laneWidth
      ctx.beginPath()
      ctx.moveTo(x, 0)
      ctx.lineTo(x, this.height)
      ctx.stroke()
    }
    ctx.setLineDash([])

    // Progress bar toward pickup
    ctx.fillStyle = "#475569"
    ctx.fillRect(0, 0, this.width, 8)
    ctx.fillStyle = "#6366f1"
    ctx.fillRect(0, 0, this.width * Math.min(this.progress, 1), 8)

    // Kid waiting at the pickup spot
    ctx.font = "28px sans-serif"
    ctx.textAlign = "center"
    ctx.fillText("🧒", this.width / 2, 40)

    // Obstacles
    this.obstacles.forEach((o) => {
      ctx.fillText(o.emoji, o.lane * this.laneWidth + this.laneWidth / 2, o.y)
    })

    // Player car
    const playerX = this.playerLane * this.laneWidth + this.laneWidth / 2
    ctx.font = "32px sans-serif"
    ctx.fillText("🚗", playerX, this.height - 60)
  }
}
