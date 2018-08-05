import store from '@/store'
import Colors from './Colors'
import debug from './Debug.js'

const CAPITAL_COLOR_ID = 4

class Cell {
  constructor ({ x, y }, $t, a, i, degree = 2.0 / 3.0 * Math.PI) {
    this._id = i
    this._a = a
    this.$t = $t
    this._isHovered = false
    this._isSelected = false
    this.__isCentered = false
    this._dy = a * Math.sin(Math.PI - degree)
    this._dx = a * Math.cos(Math.PI - degree)
    let posY = y * this._dy * 2 + (x % 2 === 1 ? this._dy : 0)
    this._points = Cell._genHexagon({ x: x * this._dx * 3, y: posY },
      { dx: this._dx, dy: this._dy },
      a, degree)
    this._planet = store.getters['planet']
    this._member = store.getters['member']
    this._shipsDec = store.getters['tasks/shipsDecreasing']
  }

  get height () {
    return this._dy * 2
  }

  // out of neighbour
  get relativeWidth () {
    return this._dx + this._a
  }

  get width () {
    return this._dx * 2 + this._a
  }

  // hex in the square
  get startPoint () {
    return {
      x: this.firstPoint.x - this._dx,
      y: this.firstPoint.y
    }
  }

  get center () {
    return {
      x: this.firstPoint.x + this._dx,
      y: this.firstPoint.y + this._dy
    }
  }

  get id () {
    return this._id
  }

  get firstPoint () {
    return this._points[0]
  }

  get isSelected () {
    return this._isSelected
  }

  set isSelected (val) {
    this._isSelected = val
  }

  get isHovered () {
    return this._isHovered
  }

  set isHovered (val) {
    this._isHovered = val
  }

  get isCentered () {
    return this._isCentered
  }

  set isCentered (val) {
    this._isCentered = val
  }

  _isPointInTriangle (A, B, C, point, eps = 0.01) {
    let area1 = this._triangleArea(A, B, point)
    let area2 = this._triangleArea(A, point, C)
    let area3 = this._triangleArea(point, B, C)
    let area = this._triangleArea(A, B, C)
    return Math.abs((area1 + area2 + area3) / area - 1) < eps
  }

  _triangleArea (A, B, C) {
    return Math.abs(A.x * (B.y - C.y) +
      B.x * (C.y - A.y) +
      C.x * (A.y - B.y)) * 0.5
  }

  render (ctx, stepsTo = 0, simply = false, simplyNoBorder = false) {
    let planet = this._planet(this._id)
    if (!planet && simplyNoBorder) {
      return
    }
    ctx.save()

    ctx.beginPath()
    Cell._drawPoints(ctx, this._points)
    ctx.lineWidth = 3
    ctx.strokeStyle = 'rgb(3, 154, 255)'
    ctx.closePath()
    let text = this.id + ''
    let memberColor = Colors['neutral']
    if (planet) {
      let member = this._member(planet.ownerID)
      if (member) {
        text = member.username
        memberColor = Colors[member.color]
      } else if (planet.isCapital) {
        text = this.$t('capital')
        memberColor = Colors[CAPITAL_COLOR_ID]
      }
      if (memberColor === undefined) {
        memberColor = Colors['invalid']
      }
      ctx.fillStyle = memberColor.bg
    } else {
      ctx.fillStyle = 'rgba(255, 255, 255, 0)'
    }
    ctx.fill()

    if (simply) {
      if (!simplyNoBorder) {
        ctx.stroke()
      }
      ctx.restore()
      return
    }

    if (planet) {
      if (this._isHovered) {
        ctx.fillStyle = 'rgba(255, 255, 255, 0.1)'
      }
      ctx.fill()
      ctx.font = '96px Material Design Icons'
      ctx.fillStyle = 'rgba(0, 0, 0, 0.3)'
      if (this.isCentered) {
        ctx.fillStyle = 'rgba(255, 255, 255, 0.3)'
      }
      ctx.textAlign = 'center'
      let planetIcon = (this._isSelected ? '\uF485' : '\uF1E7')
      ctx.fillText(planetIcon,
        this.firstPoint.x + this._a / 2,
        this.firstPoint.y + 125)
    }
    ctx.stroke()

    ctx.font = '32px Audiowide'
    if (this._isHovered) {
      text = this.id + ''
    }
    ctx.fillStyle = memberColor.text
    ctx.textAlign = 'center'
    let fontHeight = 30
    let textParts = text.match(/.{1,9}/g)
    let y = 60
    if (textParts.length > 3) {
      textParts = textParts.slice(0, 2)
      textParts[2] = '...'
    }
    textParts.forEach(part => {
      ctx.fillText(part,
        this.firstPoint.x + this._a / 2,
        this.firstPoint.y + y, 130)
      y += fontHeight
    })
    if (planet) {
      ctx.font = '18px Audiowide, Oswald'
      ctx.fillStyle = memberColor.text
      ctx.textAlign = 'center'
      if (stepsTo > 0) {
        ctx.fillText(this.$t('Steps') + ': ' + stepsTo,
          this.firstPoint.x + this._a / 2,
          this.firstPoint.y + 80)
      }
      let shipsText = planet.ships > 9999 ? this.$t('S.') : this.$t('Ships')
      let shipsCount = planet.ships - this._shipsDec(planet.id)
      if (shipsCount < 0) {
        debug.error('Count of ships is negative!', planet)
        shipsCount = 0
      }
      ctx.fillText(shipsText + ': ' + shipsCount,
        this.firstPoint.x + this._a / 2,
        this.firstPoint.y + 140)
      if (this._isHovered) {
        ctx.fillText(this.$t('Kill') + ': ' + Math.round(planet.killPerc * 100) / 100.0,
          this.firstPoint.x + this._a / 2,
          this.firstPoint.y + 120)
        let prodText = planet.production > 9999 ? this.$t('Prod') : this.$t('Production')
        ctx.fillText(prodText + ': ' + planet.production,
          this.firstPoint.x + this._a / 2,
          this.firstPoint.y + 100)
      }
    }
    ctx.restore()
  }

  isPointOver ({ x, y }) {
    let p = this.firstPoint
    if (p.x < x && x < p.x + this._a &&
        p.y < y && y < p.y + this._dy * 2) {
      return true
    }
    if (this._isPointInTriangle(p, this._points[1], this._points[2], { x, y })) {
      return true
    }
    if (this._isPointInTriangle(this._points[3],
      this._points[4], this._points[5], { x, y })) {
      return true
    }
    return false
  }

  static _drawPoints (ctx, points) {
    let { x, y } = points[0]
    ctx.beginPath()
    ctx.moveTo(x, y)
    points.forEach((point) => {
      let { x, y } = point
      ctx.lineTo(x, y)
    })
    ctx.lineTo(x, y)
  }

  static _genHexagon ({ x, y }, { dx, dy }, a, degree) {
    x += dx
    return [
      { x, y },
      {x: x - dx, y: y + dy},
      {x, y: y + 2 * dy},
      {x: x + a, y: y + 2 * dy},
      {x: x + a + dx, y: y + dy},
      {x: x + a, y}
    ]
  }
}

export default Cell
