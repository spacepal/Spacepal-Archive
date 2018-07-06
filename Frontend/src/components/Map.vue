<template>
  <canvas
    :width="width"
    :height="height"
    @mousedown="mousedown"
    @mousemove="mousemove"
    @mouseup="mouseup"
    @mousewheel="mousewheel"
    :class="canvasClass"
    ref="canvas"></canvas>
</template>

<script>
import HexagonSurface from '../common/HexagonSurface'

export default {
  name: 'Map',
  extends: HexagonSurface,
  props: {
    full: {
      type: Boolean,
      default: false
    },
    hexSize: {
      type: Number,
      default: 100
    }
  },
  data () {
    return {
      width: 2048,
      height: 1080,
      drag: false,
      hotKeys: [
        {
          code: 'KeyH',
          method: this.goHome,
          description: 'Go to center of the map'
        },
        {
          code: 'Home',
          isKey: true,
          method: this.goHome,
          description: 'Go to center of the map'
        }
      ]
    }
  },
  computed: {
    mapSizeWidth () {
      return this.$store.getters['game/info'].mapWidth || 5
    },
    mapSizeHeight () {
      return this.$store.getters['game/info'].mapHeight || 5
    },
    canvasClass () {
      let classes = []
      if (this.drag) {
        classes.push('dragged')
      }
      if (this.full) {
        classes.push('full')
      }
      return classes.join(' ')
    }
  },
  created () {
    let timeout = {
      timeout: undefined,
      doOnceAfter (func, ms) {
        clearTimeout(this.timeout)
        this.timeout = setTimeout(func, ms)
      }
    }
    this._onResizeFunc = () => {
      timeout.doOnceAfter(() => {
        this.width = document.documentElement.clientWidth
        this.height = document.documentElement.clientHeight
        this.clearOffset()
        this.tick()
      }, 300)
    }
    if (this.full) {
      this.width = document.documentElement.clientWidth
      this.height = document.documentElement.clientHeight
      window.addEventListener('resize', this._onResizeFunc)
    }
  },
  mounted () {
    let context = this.$refs.canvas.getContext('2d')
    this.init(context, this.hexSize, this.mapSizeWidth, this.mapSizeHeight)
    this._mouseUpListener = () => {
      this.drag = false
    }
    this.$store.watch((_, getters) => getters['game/info'], () => {
      if (this.mapSizeWidth !== this.mapSize.width ||
        this.mapSizeHeight !== this.mapSize.height) {
        this.init(context, this.hexSize, this.mapSizeWidth, this.mapSizeHeight)
      }
    })
    this.$store.watch((_, getters) => getters.planets, () => this.tick())
    this.$store.watch((_, getters) => getters.members, () => this.tick())
    this.$store.watch((_, getters) => getters.tasks, () => this.tick())
    window.addEventListener('mouseup', this._mouseUpListener)
  },
  beforeDestroy () {
    window.removeEventListener('mouseup', this._mouseUpListener)
    window.removeEventListener('resize', this._onResizeFunc)
  },
  methods: {
    mousewheel (event) {
      let { wheelDelta } = event
      let delta = wheelDelta / Math.abs(wheelDelta)
      this.scaleSurface(1.0 + delta * 0.1)
      this.tick()
      event.preventDefault()
      return false
    },
    mousedown (event) {
      // middle mouse button
      // or shift + left mouse button
      if (event.which === 2 || (event.which === 1 && event.shiftKey)) {
        this.play()
        this.mouse = { x: event.layerX, y: event.layerY }
        this.drag = true
        event.preventDefault()
      } else if (event.which === 1) { // left mouse button
        this.onSurfaceMouseClick({
          mx: event.layerX,
          my: event.layerY
        })
        event.preventDefault()
      }
    },
    mouseup (event) {
      this.drag = false
      this.pause()
    },
    mousemove (event) {
      if (!this.drag) {
        this.onSurfaceMouseMove({
          mx: event.layerX,
          my: event.layerY
        })
        return
      }
      let dx = event.layerX - this.mouse.x
      let dy = event.layerY - this.mouse.y
      this.mouse = { x: event.layerX, y: event.layerY }
      this.translateSurface({ dx, dy }, event.shiftKey)
    }
  }
}
</script>

<style lang="scss" scoped>
  $height: 1080;
  $width: 2048;
  $border: 1px;
  canvas {
    $margin: 4px;
    margin: $margin;
    max-width: calc(100% - #{$margin - $border * 4});
    max-height: calc(100% - #{$margin - $border * 4});
    border: $border solid rgb(54, 129, 221);
  }

  .full {
    position: fixed !important;
    border: none !important;
    left: 0 !important;
    top: 0 !important;
    width: 100% !important;
    height: 100% !important;
  }

  .dragged {
    cursor: crosshair
  }

</style>
