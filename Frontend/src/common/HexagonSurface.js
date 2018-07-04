import Cell from './Cell.js'

export default {
  data () {
    return {
      a: 0,
      dx: 0,
      dy: 0,
      context: undefined,
      scale: 1.0,
      cells: {
        all: [],
        active: []
      },
      hoveredIndex: undefined,
      pending: {
        scale: 1.0,
        dx: 0,
        dy: 0
      },
      paused: true,
      mapSize: {
        width: 0,
        height: 0
      },
      frames: 0,
      fps: 0
    }
  },
  computed: {
    renderedCount () {
      return this.cells.active.length
    }
  },
  mounted () {
    this._fpsTimeout = undefined
    let fpsFunc = () => {
      this.fps = this.frames
      this.frames = 0
      this._fpsTimeout = setTimeout(fpsFunc, 1000)
    }
    fpsFunc()
  },
  beforeDestroy () {
    clearTimeout(this._fpsTimeout)
  },
  methods: {
    _genSurface (a) {
      for (let y = 0, count = 1; y < this.mapSize.height; ++y) {
        for (let x = 0; x < this.mapSize.width; ++x) {
          this.cells.all.push(new Cell({ x, y }, a, count++))
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
      let cell = this._resolveCell(this.context, { mx, my })
      if (cell) {
        this.$toast(`${cell.id} is clicked`)
      }
      console.warn(`@todo HexagonSurface: onSurfaceMouseClick ${mx}, ${my}`)
    },
    _resolveCell (ctx, {mx, my}) {
      let calc = this._relPosCalculator(ctx)
      let pos = calc({x: mx, y: my})
      return this.cells.active.find(cell => cell.isPointOver(pos))
    },
    onSurfaceMouseMove ({ mx, my }) {
      if (this._moveLock) {
        return
      }
      this._moveLock = true

      if (this.hoveredIndex !== undefined) {
        this.cells.all[this.hoveredIndex].isHovered = false
        this.cells.all[this.hoveredIndex].render(this.context)
      }

      let cell = this._resolveCell(this.context, {mx, my})
      if (cell) {
        cell.isHovered = true
        this.hoveredIndex = cell.id - 1
        cell.render(this.context)
      }
      this._moveLock = false
    },
    // _getNeighbours (index) {
    //   let neighbours = []
    //   let addIfValid = i => {
    //     if (i > 0 && i < this.mapSize.height * this.mapSize.width) {
    //       neighbours.push(i)
    //     }
    //   }
    //   addIfValid(index - this.mapSize.width)
    //   addIfValid(index + this.mapSize.width)
    //   addIfValid(index - 1)
    //   addIfValid(index + 1)
    //   let oddEvenFactor = index % this.mapSize.width % 2 === 0 ? -1 : +1
    //   addIfValid(index + oddEvenFactor * this.mapSize.width - 1)
    //   addIfValid(index + oddEvenFactor * this.mapSize.width + 1)
    //   return neighbours
    // },
    pause () {
      this.paused = true
    },
    play () {
      this.paused = false
    },
    init (ctx, a, mapSizeWidth, mapSizeHeight) {
      this.a = a
      this.mapSize.width = mapSizeWidth
      this.mapSize.height = mapSizeHeight
      this.context = ctx
      this._genSurface(a)
      let tick = () => {
        if (!this.paused) {
          this.redraw(this.context)
        }
        requestAnimationFrame(tick)
      }
      this.goHome()
      requestAnimationFrame(tick)
    },
    tick () {
      requestAnimationFrame(() => this.redraw(this.context))
    },
    translateSurface ({dx, dy}, considerScale = false) {
      this.pending.dx += dx * (considerScale ? 1.0 / this.scale : 1.0)
      this.pending.dy += dy * (considerScale ? 1.0 / this.scale : 1.0)
    },
    scaleSurface (scale) {
      this.pending.scale *= scale
    },
    goHome () {
      let ctx = this.context
      this._scaleOverCenter(ctx, 1.0 / this.scale)
      ctx.translate(-this.dx, -this.dy)
      this.scale = 1.0
      this.dx = -ctx.canvas.width / 2.0
      this.dy = -ctx.canvas.height / 2.0
      ctx.translate(this.dx, this.dy)
      this.tick()
    },
    _scaleOverCenter (ctx, scale) {
      let { width, height } = ctx.canvas
      let cx = width * 0.5
      let cy = height * 0.5
      ctx.clearRect(-width, -height, width * 10, height * 10)
      ctx.translate(cx - this.dx, cy - this.dy)
      ctx.scale(scale, scale)
      ctx.translate(-cx + this.dx, -cy + this.dy)
    },
    clearOffset () {
      this.dx = 0
      this.dy = 0
    },
    redraw (ctx) {
      let { scale, dx, dy } = this.pending
      this.pending = { scale: 1.0, dx: 0.0, dy: 0.0 }

      this.dx += dx
      this.dy += dy
      this.scale *= scale

      this._scaleOverCenter(ctx, scale)
      ctx.translate(dx, dy)

      let realPosCalc = this._relPosCalculator()
      let rect = this.context.canvas.getBoundingClientRect()
      let visibilityOffset = this.a * this.scale
      let startPoint = realPosCalc({
        x: -visibilityOffset * 1.5,
        y: -visibilityOffset * 1.5
      })
      let endPoint = realPosCalc({
        x: rect.width + visibilityOffset,
        y: rect.height + visibilityOffset
      })
      this.cells.active = this.cells.all.filter(cell => {
        if (cell.firstPoint.x > startPoint.x &&
          cell.firstPoint.x < endPoint.x &&
          cell.firstPoint.y > startPoint.y &&
          cell.firstPoint.y < endPoint.y) {
          cell.render(ctx)
          return true
        }
      })
      this.frames++
    }
  }
}
