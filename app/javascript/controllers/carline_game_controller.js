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

  WIN_MESSAGES = [
    "🎉 Your kid hopped in! You are now legally cleared to speed to Chick-fil-A.",
    "🎉 Your kid hopped in! You will now make it to karate with exactly 2.7 minutes to spare.",
    "🎉 Your kid hopped in! Zoom to Costco before they run out of rotisserie chicken. God be with you.",
    "🎉 Your kid hopped in! Time to referee the backseat shotgun lawsuit. Bring a gavel.",
    "🎉 Your kid hopped in! Circle back for the forgotten cleats. You knew this was coming.",
    "🎉 Your kid hopped in! Buckle up for 47 uninterrupted minutes of Minecraft lore.",
    "🎉 Your kid hopped in! Get ready to explain, for the 900th time, why ice cream is not a dinner option.",
    "🎉 Your kid hopped in! You've earned a trip to Duck Donuts. No judgement."
  ]

  GRAVITY = 1700 // px/s^2 — floaty on purpose, easy to time
  JUMP_VELOCITY = -620 // px/s — tuned to clear obstacles without leaving the shorter canvas, ~730ms full airtime
  PLAYER_X_RATIO = 0.22
  GROUND_MARGIN = 55
  CLEAR_HEIGHT = 30 // how high off the ground counts as "cleared it" — generous
  HIT_RADIUS = 16
  MIN_SPAWN_GAP_MS = 1500 // level 1's runway; later levels tighten this
  MIN_SPAWN_GAP_FLOOR_MS = 1050 // ~320ms of reaction buffer past a full ~730ms jump, even at max difficulty
  MAX_OBSTACLE_SPEED = 255 // px/s cap — keeps spawn-to-player travel time from dropping below ~1s

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
    // Levels get LONGER as you go up (more time in "carline" = more obstacles
    // to survive), floor keeps it from dragging forever at high levels.
    this.speed = Math.max(0.05, 0.11 - (this.level - 1) * 0.008)
    // Obstacles spawn more often and cross faster each level; both capped so
    // the runway between them never drops below what a jump physically needs.
    this.spawnChance = Math.min(0.05, 0.012 + (this.level - 1) * 0.004)
    this.obstacleSpeed = Math.min(this.MAX_OBSTACLE_SPEED, 130 + (this.level - 1) * 14) // px/sec
    this.spawnGapMs = Math.max(this.MIN_SPAWN_GAP_FLOOR_MS, this.MIN_SPAWN_GAP_MS - (this.level - 1) * 55)
    this.obstacles = []
    this.running = true
    this.graceMs = 1200
    this.timeSinceSpawn = this.spawnGapMs // eligible to spawn right after grace ends
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
    // Physics runs even during the grace period, or a practice jump leaves
    // onGround stuck false (it's only ever reset in this block) and every
    // real jump for the rest of the level silently does nothing.
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

    this.timeSinceSpawn += dt
    if (this.timeSinceSpawn >= this.spawnGapMs && Math.random() < this.spawnChance) {
      const kind = this.OBSTACLE_KINDS[Math.floor(Math.random() * this.OBSTACLE_KINDS.length)]
      this.obstacles.push({ x: this.width + 20, ...kind })
      this.timeSinceSpawn = 0
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
    const message = this.WIN_MESSAGES[(this.level - 1) % this.WIN_MESSAGES.length]
    this.statusTarget.innerHTML = message
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
