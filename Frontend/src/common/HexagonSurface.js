import Cell from './Cell.js'

export default {
  data () {
    return {
      dx: 0,
      dy: 0,
      context: undefined,
      scale: 1.0,
      cells: [],
      hoveredIndex: undefined,
      pending: {
        scale: 1.0,
        dx: 0,
        dy: 0
      },
      paused: true
    }
  },
  methods: {
    _genSurface (a) {
      for (let y = 0, count = 1; y < this.mapSizeHeight; ++y) {
        for (let x = 0; x < this.mapSizeWidth; ++x) {
          this.cells.push(new Cell({ x, y }, a, count++))
        }
      }
    },
    _relPosCalculator () {
      let { width, height } = this.context.canvas
      let rect = this.context.canvas.getBoundingClientRect()
      let globScale = { // DOM
        x: width / rect.width,
        y: height / rect.height
      }
      return ({x, y}) => {
        x *= globScale.x
        y *= globScale.y

        x += -width * 0.5 * (1 - this.scale)
        x /= this.scale
        x -= this.dx

        y += -height * 0.5 * (1 - this.scale)
        y /= this.scale
        y -= this.dy

        return { x, y }
      }
    },
    onSurfaceMouseClick ({ mx, my }) {
      console.warn(`@todo HexagonSurface: onSurfaceMouseClick ${mx}, ${my}`)
    },
    onSurfaceMouseMove ({mx, my}) {
      if (this._moveLock) {
        return
      }
      this._moveLock = true
      let ctx = this.context
      if (this.hoveredIndex !== undefined) {
        this.cells[this.hoveredIndex].isHovered = false
        this.cells[this.hoveredIndex].render(ctx)
      }
      let calc = this._relPosCalculator(ctx)
      let pos = calc({x: mx, y: my})
      this.cells.forEach((cell, i) => {
        if (cell.isPointOver(pos)) {
          this.hoveredIndex = i
          cell.isHovered = true
          cell.render(ctx, true)
        }
      })
      this._moveLock = false
    },
    pause () {
      this.paused = true
    },
    play () {
      this.paused = false
    },
    init (ctx, a) {
      this.context = ctx
      this._genSurface(a)
      let tick = () => {
        if (!this.paused) {
          this.redraw(this.context)
        }
        requestAnimationFrame(tick)
      }
      this.tick()
      requestAnimationFrame(tick)
    },
    tick () {
      requestAnimationFrame(() => this.redraw(this.context))
    },
    translateSurface ({dx, dy}) {
      this.pending.dx += dx
      this.pending.dy += dy
    },
    scaleSurface (scale) {
      this.pending.scale *= scale
    },
    redraw (ctx) {
      let { scale, dx, dy } = this.pending
      this.pending = { scale: 1.0, dx: 0.0, dy: 0.0 }

      let { width, height } = ctx.canvas
      this.dx += dx
      this.dy += dy
      this.scale *= scale
      let sx = width * 0.5
      let sy = height * 0.5
      ctx.clearRect(-1000, -1000, width * 10, height * 10)
      ctx.translate(sx - this.dx, sy - this.dy)
      ctx.scale(scale, scale)
      ctx.translate(-sx + this.dx, -sy + this.dy)
      ctx.translate(dx, dy)
      this.cells.forEach(cell => {
        cell.render(ctx)
      })
    }
  }
}
