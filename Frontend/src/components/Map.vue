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
      ref="canvas"></canvas>
    <Window type="confirm" ref="taskWindow" title="Create task"
      @confirm="taskConfirm" @reject="taskReject" :enabled="task.isValid">
      <Form ref="taskForm" class="withoutborder">
        <TextInput type="number"
          :label="`Max ships count: ${task.maxCount}`"
          :min="1" :max="task.maxCount"
          v-model="task.count"
          @change="checkTaskForm"></TextInput>
      </Form>
    </Window>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import HexagonSurface from '../common/HexagonSurface'
import Window from './Window'
import TextInput from './TextInput'
import Form from './Form'

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
  components: { Window, TextInput, Form },
  data () {
    return {
      task: {
        from: null,
        to: null,
        count: 0,
        maxCount: 0,
        isAutoTask: false,
        isValid: false
      },
      width: 2048,
      height: 1080,
      drag: false,
      hotKeys: [
        {
          code: 'KeyH',
          method: this.goHome,
          description: 'Go to your planet'
        },
        {
          code: 'Home',
          isKey: true,
          method: this.goHome,
          description: 'Go to your planet'
        },
        {
          code: 'Escape',
          isKey: true,
          method: this.unselectLastCell
        }
      ]
    }
  },
  computed: {
    ...mapGetters({
      isOwner: 'isMemberPlanetOwner',
      availableShips: 'tasks/availableShips',
      isLocked: 'isLocked'
    }),
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
    this.$store.watch((_, getters) => getters['tasks/all'], () => this.tick())
    window.addEventListener('mouseup', this._mouseUpListener)
  },
  beforeDestroy () {
    window.removeEventListener('mouseup', this._mouseUpListener)
    window.removeEventListener('resize', this._onResizeFunc)
  },
  methods: {
    checkTaskForm () {
      this.task.isValid = this.$refs.taskForm.isValid()
    },
    taskConfirm () {
      if (this.task.isValid) {
        this.$store.dispatch('tasks/add', this.task)
        this.taskReject()
      }
    },
    taskReject () {
      this.task.from = null
      this.task.to = null
      this.task.maxCount = null
      this.task.count = null
    },
    showShipsDialog () {
      this.$refs.taskWindow.show()
    },
    planetClicked (planet) {
      if (this.isLocked) {
        return
      }
      if (this.task.from !== null) {
        this.unselectLastCell()
        if (this.task.from !== planet.id) {
          this.task.to = planet.id
          this.showShipsDialog()
        } else {
          this.taskReject()
        }
      } else if (!this.isOwner(planet.id)) {
        this.$toast(`This is foreign planet`)
      } else if (this.availableShips(planet.id) <= 0) {
        this.$toast(`Lack of ships`)
      } else {
        this.selectCell(planet.cellID - 1)
        this.task.from = planet.id
        this.task.maxCount = this.availableShips(planet.id)
        this.task.count = 0
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
