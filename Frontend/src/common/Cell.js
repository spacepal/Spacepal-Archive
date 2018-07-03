class Cell {
  constructor ({x, y}, a, i, degree = 2.0 / 3.0 * Math.PI) {
    this._id = i
    this._a = a
    this._isHovered = false
    this._dy = a * Math.sin(Math.PI - degree)
    let dx = a * Math.cos(Math.PI - degree)
    let posY = y * this._dy * 2 + (x % 2 === 1 ? this._dy : 0)
    this._points = Cell._genHexagon({ x: x * dx * 3, y: posY }, a, degree)
  }

  get id () {
    return this._id
  }

  get firstPoint () {
    return this._points[0]
  }

  get isHovered () {
    return this._isHovered
  }

  set isHovered (val) {
    this._isHovered = val
  }

  render (ctx, onlyFill = false) {
    ctx.save()
    ctx.beginPath()
    Cell._drawPoints(ctx, this._points)
    ctx.lineWidth = 2
    ctx.shadowColor = 'rgb(3, 154, 255)'
    ctx.shadowBlur = 10
    ctx.shadowOffsetY = 0
    ctx.strokeStyle = 'rgb(119, 180, 255)'
    ctx.shadowOffsetX = 0
    ctx.closePath()
    if (this._isHovered) {
      ctx.fillStyle = 'rgb(119, 180, 255)'
    } else {
      ctx.fillStyle = 'black'
    }
    ctx.fill()
    if (!onlyFill) {
      ctx.stroke()
    }
    ctx.restore()
    ctx.font = '32px Audiowide'
    ctx.fillStyle = 'rgb(0, 85, 141)'
    ctx.textAlign = 'center'
    ctx.fillText(this.id + '',
      this.firstPoint.x + this._a / 2,
      this.firstPoint.y + 40)
  }

  isPointOver ({x, y}) {
    let p = this.firstPoint
    if (p.x < x && x < p.x + this._a &&
        p.y < y && y < p.y + this._dy * 2) {
      return true
    }
    return false
  }

  static _drawPoints (ctx, points) {
    let {x, y} = points[0]
    ctx.beginPath()
    ctx.moveTo(x, y)
    points.forEach((point) => {
      let {x, y} = point
      ctx.lineTo(x, y)
    })
    ctx.lineTo(x, y)
  }

  static _genHexagon ({x, y}, a, degree) {
    let dx = a * Math.cos(Math.PI - degree)
    let dy = a * Math.sin(Math.PI - degree)
    x += dx
    return [
      {x, y},
      {x: x - dx, y: y + dy},
      {x, y: y + 2 * dy},
      {x: x + a, y: y + 2 * dy},
      {x: x + a + dx, y: y + dy},
      {x: x + a, y}
    ]
  }
}

export default Cell
