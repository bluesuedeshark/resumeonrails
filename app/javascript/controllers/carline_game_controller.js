import { Controller } from "@hotwired/stimulus"

// Chrome-dino-style jump game: one input (tap/click/space), jump over
// obstacles crossing the road, get to your kid before the timer runs out.
// Single-input on purpose — it's meant to be playable one-thumb, mid-carline.
export default class extends Controller {
  static targets = ["canvas", "status", "level"]

  OBSTACLE_KINDS = [
    { emoji: "🚧", label: "a traffic cone someone knocked over" },
    { emoji: "🐕", label: "a dog making a break for it" },
    { emoji: "🧸", label: "a dropped stuffed animal" },
    { emoji: "🛑", label: "the crossing guard's stop sign" }
  ]

  GRAVITY = 1700 // px/s^2 — floaty on purpose, easy to time
  JUMP_VELOCITY = -700 // px/s
  PLAYER_X_RATIO = 0.22
  GROUND_MARGIN = 60
  CLEAR_HEIGHT = 30 // how high off the ground counts as "cleared it" — generous
  HIT_RADIUS = 16

  connect() {
    this.ctx = this.canvasTarget.getContext("2d")
    this.width = this.canvasTarget.width
    this.height = this.canvasTarget.height
    this.playerX = this.width * this.PLAYER_X_RATIO
    this.groundY = this.height - this.GROUND_MARGIN
    this.running = false
    this.level = 1
    this.boundKeydown = this.handleKeydown.bind(this)
    this.boundPointerdown = this.handlePointerdown.bind(this)
    this.canvasTarget.addEventListener("pointerdown", this.boundPointerdown)
    this.drawIdleFrame()
  }

  disconnect() {
    this.stopLoop()
    document.removeEventListener("keydown", this.boundKeydown)
    this.canvasTarget.removeEventListener("pointerdown", this.boundPointerdown)
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
    this.playerY = this.groundY
    this.velocityY = 0
    this.onGround = true
    this.progress = 0
    this.speed = 0.1 + (this.level - 1) * 0.02
    this.spawnChance = 0.01 + (this.level - 1) * 0.003
    this.obstacleSpeed = 130 + (this.level - 1) * 18 // px/sec
    this.obstacles = []
    this.running = true
    this.graceMs = 1200
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
    if (event.key === " " || event.key === "ArrowUp" || event.code === "Space") {
      event.preventDefault()
      this.jump()
    }
  }

  handlePointerdown() {
    this.jump()
  }

  jump() {
    if (!this.running) return
    if (this.onGround) {
      this.velocityY = this.JUMP_VELOCITY
      this.onGround = false
    }
  }

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
    // Physics always runs, even during the grace period — otherwise a practice
    // jump during "get ready" leaves onGround stuck false for the whole level,
    // and every real jump attempt after that silently does nothing. (This was
    // the actual bug: jump() only fires when onGround, and onGround only ever
    // got reset back to true in the block that grace used to skip entirely.)
    this.velocityY += (this.GRAVITY * dt) / 1000
    this.playerY += (this.velocityY * dt) / 1000
    if (this.playerY >= this.groundY) {
      this.playerY = this.groundY
      this.velocityY = 0
      this.onGround = true
    }

    if (this.graceMs > 0) {
      this.graceMs -= dt
      return
    }

    this.progress += (this.speed * dt) / 1000

    if (Math.random() < this.spawnChance) {
      const kind = this.OBSTACLE_KINDS[Math.floor(Math.random() * this.OBSTACLE_KINDS.length)]
      this.obstacles.push({ x: this.width + 20, ...kind })
    }

    this.obstacles.forEach((o) => (o.x -= (this.obstacleSpeed * dt) / 1000))
    this.obstacles = this.obstacles.filter((o) => o.x > -40)

    for (const o of this.obstacles) {
      if (Math.abs(o.x - this.playerX) < this.HIT_RADIUS) {
        const clearance = this.groundY - this.playerY
        if (clearance < this.CLEAR_HEIGHT) {
          this.fail(o.label)
          return
        }
      }
    }

    if (this.progress >= 1) {
      this.win()
    }
  }

  fail(reason) {
    this.running = false
    document.removeEventListener("keydown", this.boundKeydown)
    this.statusTarget.innerHTML = `🚗💥 Didn't clear ${reason}.<br>Guess you're still stuck in car line. Better luck at 2:45 tomorrow.`
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
    ctx.fillStyle = "#e2e8f0"
    ctx.font = "bold 15px sans-serif"
    ctx.textAlign = "center"
    ctx.fillText("Tap to jump over stuff. Get your kid 🧒.", this.width / 2, this.height / 2 - 10)
    ctx.fillStyle = "#94a3b8"
    ctx.font = "13px sans-serif"
    ctx.fillText("Press Start.", this.width / 2, this.height / 2 + 14)
  }

  draw() {
    const ctx = this.ctx
    ctx.fillStyle = "#1e293b"
    ctx.fillRect(0, 0, this.width, this.height)

    // Ground line
    ctx.strokeStyle = "#334155"
    ctx.beginPath()
    ctx.moveTo(0, this.groundY + 24)
    ctx.lineTo(this.width, this.groundY + 24)
    ctx.stroke()

    // Progress bar, labeled
    ctx.fillStyle = "#475569"
    ctx.fillRect(0, 0, this.width, 10)
    ctx.fillStyle = "#6366f1"
    ctx.fillRect(0, 0, this.width * Math.min(this.progress, 1), 10)
    ctx.fillStyle = "#cbd5e1"
    ctx.font = "10px sans-serif"
    ctx.textAlign = "left"
    ctx.fillText("progress to pickup", 4, 22)

    // Kid waiting
    ctx.font = "28px sans-serif"
    ctx.textAlign = "center"
    ctx.fillText("🧒", this.width - 30, this.groundY - 6)

    if (this.graceMs > 0) {
      ctx.fillStyle = "#e2e8f0"
      ctx.font = "bold 16px sans-serif"
      ctx.fillText("Get ready…", this.width / 2, this.height / 2)
      ctx.font = "12px sans-serif"
      ctx.fillStyle = "#94a3b8"
      ctx.fillText("tap or press space to test a jump", this.width / 2, this.height / 2 + 20)
    }

    // Obstacles
    this.obstacles.forEach((o) => {
      ctx.font = "26px sans-serif"
      ctx.textAlign = "center"
      ctx.fillText(o.emoji, o.x, this.groundY)
    })

    // Player car (rises off the ground when jumping)
    ctx.font = "32px sans-serif"
    ctx.fillText("🚗", this.playerX, this.playerY)
  }
}
