<template>
  <div>
    <canvas
      :width="width"
      :height="height"
      @mousedown="mousedown"
      @mousemove="mousemove"
      @mouseup="mouseup"
      @wheel="mousewheel"
      :class="canvasClass"
      :style="bgPosStyle"
      ref="canvas"></canvas>
    <TaskWin ref="taskWin" @cancel="taskReject" @confirm="taskConfirm" />
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import HexagonSurface from '../common/HexagonSurface'
import TaskWin from '../components/win/TaskWin'

const PARALLAX = 34 // divider
const RESOLUTION_FACTOR = 1.5
const KEY_SCALE_FACTOR = 0.04 // for '+' and '-'
const KEY_LARGE_SCALE_FACTOR = 0.5
const KEY_TRANSLATE = 18 // Arrow keys

export default {
  name: 'Map',
  extends: HexagonSurface,
  props: {
    offsetX: {
      type: Number,
      default: 0
    },
    full: {
      type: Boolean,
      default: false
    },
    hexSize: {
      type: Number,
      default: 100
    }
  },
  components: {
    TaskWin
  },
  data () {
    return {
      renderWithoutDecreasing: false,
      mouse: {
        x: 0,
        y: 0
      },
      isBookmarkMode: false,
      taskFrom: null,
      width: 2048,
      height: 1080,
      drag: false,
      hotKeys: [
        {
          code: 'KeyY',
          methodDown: () => {
            this.renderWithoutDecreasing = true
            this.$nextTick(() => {
              this.tick()
            })
          },
          method: () => {
            this.renderWithoutDecreasing = false
            this.$nextTick(() => {
              this.tick()
            })
          },
          description: this.$t('Show ships without tasks')
        },
        {
          code: 'ArrowDown',
          methodDown: () => {
            this.translateSurface({ dx: 0, dy: -KEY_TRANSLATE }, true)
            this.tick()
          },
          isKey: true
        },
        {
          code: 'ArrowUp',
          methodDown: () => {
            this.translateSurface({ dx: 0, dy: +KEY_TRANSLATE }, true)
            this.tick()
          },
          isKey: true
        },
        {
          code: 'ArrowLeft',
          methodDown: () => {
            this.translateSurface({ dx: +KEY_TRANSLATE, dy: 0 }, true)
            this.tick()
          },
          isKey: true
        },
        {
          code: 'ArrowRight',
          methodDown: () => {
            this.translateSurface({ dx: -KEY_TRANSLATE, dy: 0 }, true)
            this.tick()
          },
          isKey: true
        },
        {
          code: 'PageUp',
          isKey: true,
          description: this.$t('Zoom+'),
          method: () => {
            this.scaleSurface(1.0 + KEY_LARGE_SCALE_FACTOR)
            this.tick()
          }
        },
        {
          code: 'PageDown',
          isKey: true,
          description: this.$t('Zoom-'),
          method: () => {
            this.scaleSurface(1.0 - KEY_LARGE_SCALE_FACTOR)
            this.tick()
          }
        },
        {
          code: '+',
          isKey: true,
          methodDown: this.play,
          methodPress: this.zoomUp,
          description: this.$t('Zoom+'),
          method: this.safePause
        },
        {
          code: '=',
          isKey: true,
          methodDown: this.play,
          methodPress: this.zoomUp,
          method: this.safePause
        },
        {
          code: '-',
          isKey: true,
          methodDown: this.play,
          methodPress: this.zoomDown,
          description: this.$t('Zoom-'),
          method: this.safePause
        },
        {
          code: '*',
          isKey: true,
          method: this.zoomReset,
          description: this.$t('Default zoom')
        },
        {
          code: '0',
          isKey: true,
          method: this.zoomReset,
          description: this.$t('Default zoom')
        },
        {
          code: 'KeyH',
          method: this.goHome,
          description: this.$t('Your best planet')
        },
        {
          code: 'Home',
          isKey: true,
          method: this.goHome,
          description: this.$t('Your best planet')
        },
        {
          code: 'Escape',
          isKey: true,
          method: () => {
            this.taskReject()
          }
        },
        {
          code: 'KeyB',
          methodDown: () => {
            this.isBookmarkMode = true
          },
          method: () => {
            this.isBookmarkMode = false
          }
        },
        {
          code: 'KeyR',
          method: this.toggleArrows,
          description: this.$t('Show directions')
        }
      ]
    }
  },
  computed: {
    ...mapGetters({
      isOwner: 'isMemberPlanetOwner',
      availableShips: 'tasks/availableShips',
      isLocked: 'isLocked',
      fullRender: 'settings/fullRender'
    }),
    bgPosStyle () {
      if (this.fullRender) {
        return {
          backgroundPosition: `${-this.dx / PARALLAX}px ${-this.dy / PARALLAX}px`
        }
      }
      return { }
    },
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
        if (this.full) {
          this.width = document.documentElement.clientWidth
          this.height = document.documentElement.clientHeight
        } else {
          let canvas = this.$refs.canvas
          this.width = canvas.offsetWidth
          this.height = canvas.offsetHeight
        }
        this.width *= RESOLUTION_FACTOR
        this.height *= RESOLUTION_FACTOR
        this.clearOffset()
        this.$nextTick(() => {
          this.goHome()
        })
        this.tick()
      }, 300)
    }
  },
  mounted () {
    this._touchStartListener = event => {
      this.play()
      this.mouse = { x: event.touches[0].clientX, y: event.touches[0].clientY }
      this.drag = true
      event.preventDefault()
    }
    this._touchEndListener = event => {
      this.drag = false
      this.$nextTick(this.pause)
      this.tick()
    }
    this._touchMoveListener = event => {
      if (this.drag) {
        this.mousemove({
          layerX: event.touches[0].clientX,
          layerY: event.touches[0].clientY
        })
        event.preventDefault()
      }
    }
    window.addEventListener('touchstart', this._touchStartListener)
    window.addEventListener('touchend', this._touchEndListener)
    window.addEventListener('touchcancel', this._touchEndListener)
    window.addEventListener('touchmove', event => this._touchMoveListener)

    window.addEventListener('resize', this._onResizeFunc)
    this._onResizeFunc()

    let context = this.$refs.canvas.getContext('2d')
    this.init(context, this.hexSize, this.mapSizeWidth,
      this.mapSizeHeight, this.offsetX)
    this._mouseUpListener = () => {
      this.drag = false
      this.pause()
      this.tick()
    }
    this._unwatch = []
    this._unwatch.push(
      this.$store.watch((_, getters) => getters.sync['game'], (info) => {
        if (this.mapSizeWidth !== this.mapSize.width ||
          this.mapSizeHeight !== this.mapSize.height) {
          this.init(context, this.hexSize, this.mapSizeWidth,
            this.mapSizeHeight, this.offsetX)
        }
      }))
    this._unwatch.push(
      this.$store.watch((_, getters) => getters.sync['planets'],
        () => this.tick()))
    this._unwatch.push(
      this.$store.watch((_, getters) => getters.sync['members'],
        () => this.tick()))
    this._unwatch.push(
      this.$store.watch((_, getters) => getters['tasks/all'],
        () => this.tick()))
    window.addEventListener('mouseup', this._mouseUpListener)
  },
  beforeDestroy () {
    window.removeEventListener('mouseup', this._mouseUpListener)
    window.removeEventListener('resize', this._onResizeFunc)
    window.removeEventListener('touchstart', this._touchStartListener)
    window.removeEventListener('touchend', this._touchEndListener)
    window.removeEventListener('touchcancel', this._touchEndListener)
    window.removeEventListener('touchmove', event => this._touchMoveListener)
    this._unwatch.forEach(unwatch => {
      unwatch()
    })
  },
  methods: {
    toggleArrows () {
      this.arrowsMode ^= true
      this.$nextTick(this.tick)
    },
    safePause () {
      if (this.drag) {
        this.pause()
      }
    },
    zoomUp () {
      this.scaleSurface(1.0 + KEY_SCALE_FACTOR)
    },
    zoomDown () {
      this.scaleSurface(1.0 - KEY_SCALE_FACTOR)
    },
    zoomReset () {
      this.scaleSurface(0)
      this.tick()
    },
    taskConfirm (task) {
      this.$store.dispatch('tasks/add', task)
      this.unselectLastCell()
      this.taskFrom = null
    },
    taskReject () {
      this.unselectLastCell()
      this.taskFrom = null
    },
    showShipsDialog (taskTo) {
      let shipsCount = this.availableShips(this.taskFrom)
      this.$refs.taskWin.show({
        from: this.taskFrom,
        to: taskTo,
        maxCount: shipsCount,
        count: shipsCount,
        isHoldAutoTask: shipsCount === 0,
        isDispatchAutoTask: false
      })
    },
    planetClicked (planet) {
      if (this.isBookmarkMode) {
        this.$emit('addBookmark', planet.id)
        return
      }
      if (this.isLocked) {
        return
      }
      if (this.taskFrom !== null) {
        if (this.simplyRender) {
          this.$toast(this.$t('Zoom in for action'))
          return
        }
        if (this.taskFrom !== planet.id) {
          this.showShipsDialog(planet.id)
        } else {
          this.taskReject()
        }
      } else if (!this.isOwner(planet.id)) {
        if (planet.ownerID === -1) {
          this.$toast(this.$t('This is neutral planet'))
        } else {
          this.$toast(this.$t('This is foreign planet'))
        }
      } else {
        if (this.simplyRender) {
          this.$toast(this.$t('Zoom in for action'))
          return
        }
        this.selectCell(planet.cellID - 1)
        this.taskFrom = planet.id
      }
    },
    mousewheel (event) {
      let { deltaY } = event
      let delta = -deltaY / Math.abs(deltaY)
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
        let p = this.resolvePlanet({ mx: event.layerX, my: event.layerY })
        if (p) {
          this.planetClicked(p)
        }
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
      this.translateSurface({ dx, dy }, !event.shiftKey)
    }
  }
}
</script>

<style lang="scss" scoped>
  $height: 1080;
  $width: 2048;
  $border: 1px;
  canvas {
    $margin: 2px;
    margin: $margin;
    width: 100%;
    height: 100%;
    border: $border solid rgb(54, 129, 221);
    background: url('/static/background.jpg');
    background-size: cover;
  }

  .full {
    position: fixed !important;
    border: none !important;
    left: 0 !important;
    top: 0 !important;
    width: 100% !important;
    height: 100% !important;
    margin: 0 !important;
    padding: 0 !important;
  }

  .dragged {
    cursor: crosshair;
  }

</style>
