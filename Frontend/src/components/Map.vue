<template>
  <div id="surface">
    <canvas
      :width="width"
      :height="height"
      @mousedown="mousedown"
      @mousemove="mousemove"
      @mouseup="mouseup"
      @mousewheel="mousewheel"
      :class="canvasClass"
      ref="canvas"></canvas>
  </div>
</template>

<script>
import HexagonSurface from '../common/HexagonSurface'
export default {
  name: 'Map',
  extends: HexagonSurface,
  props: {
    mapSizeWidth: {
      type: Number,
      default: 24
    },
    mapSizeHeight: {
      type: Number,
      default: 12
    },
    hexSize: {
      type: Number,
      default: 100
    }
  },
  data () {
    return {
      width: 1920,
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
    canvasClass () {
      return this.drag ? 'dragged' : ''
    }
  },
  mounted () {
    let context = this.$refs.canvas.getContext('2d')
    this.init(context, this.hexSize, this.mapSizeWidth, this.mapSizeHeight)
    this._mouseUpListener = () => {
      this.drag = false
    }
    window.addEventListener('mouseup', this._mouseUpListener)
  },
  beforeDestroy () {
    window.removeEventListener('mouseup', this._mouseUpListener)
  },
  methods: {
    mousewheel ({wheelDelta, layerX, layerY}) {
      let delta = wheelDelta / Math.abs(wheelDelta)
      this.scaleSurface(1.0 + delta * 0.1)
      this.tick()
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
      this.translateSurface({ dx, dy })
    }
  }
}
</script>

<style lang="scss" scoped>
#surface {
  position: absolute;
  left: 0;
  top: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
  margin: 0;

  canvas {
    $height: 1080;
    $width: 1920;
    max-width: 80vw;
    max-height: 90vh;
    border: 1px solid rgb(54, 129, 221);
  }

  .dragged {
    cursor: crosshair
  }
}
</style>
