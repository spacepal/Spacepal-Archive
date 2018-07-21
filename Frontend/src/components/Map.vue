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
          :min="(isAutoTask ? 0 : 1)"
          :max="(isAutoTask ? Number.MAX_VALUE : task.maxCount)"
          v-model="task.count"
          @change="checkTaskForm"></TextInput>
        <div class="flex-horizontal">
          <SwitchBox :label="'Hold' + autoTaskLabel({hold: true, dispatch: false})"
            title="Create autotask that hold ships on the planet"
            v-model="task.isHoldAutoTask"
            @change="onHold(); checkTaskForm()" />
          <SwitchBox :label="'Dispatch' + autoTaskLabel({hold: false, dispatch: true})"
            title="Create autotask that dispatch ships from the planet"
            v-model="task.isDispatchAutoTask"
            @change="onDispatch(); checkTaskForm()" />
        </div>
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
import SwitchBox from './SwitchBox'

const RESOLUTION_FACTOR = 1.5

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
  components: { Window, TextInput, Form, SwitchBox },
  data () {
    return {
      task: {
        from: null,
        to: null,
        count: 0,
        maxCount: 0,
        isHoldAutoTask: false,
        isDispatchAutoTask: false,
        isValid: false
      },
      width: 2048,
      height: 1080,
      drag: false,
      hotKeys: [
        {
          code: 'Space',
          method: this.autoTask
        },
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
    isAutoTask () {
      return this.task.isHoldAutoTask || this.task.isDispatchAutoTask
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
    window.addEventListener('resize', this._onResizeFunc)
    this._onResizeFunc()

    let context = this.$refs.canvas.getContext('2d')
    this.init(context, this.hexSize, this.mapSizeWidth,
      this.mapSizeHeight, this.offsetX)
    this._mouseUpListener = () => {
      this.drag = false
    }
    this.$store.watch((_, getters) => getters.sync['game'], () => {
      if (this.mapSizeWidth !== this.mapSize.width ||
        this.mapSizeHeight !== this.mapSize.height) {
        this.init(context, this.hexSize, this.mapSizeWidth,
          this.mapSizeHeight, this.offsetX)
      }
    })
    this.$store.watch((_, getters) => getters.planets, () => this.tick())
    this.$store.watch((_, getters) => getters.sync['members'], () => this.tick())
    this.$store.watch((_, getters) => getters['tasks/all'], () => this.tick())
    window.addEventListener('mouseup', this._mouseUpListener)
  },
  beforeDestroy () {
    window.removeEventListener('mouseup', this._mouseUpListener)
    window.removeEventListener('resize', this._onResizeFunc)
  },
  methods: {
    autoTaskLabel({hold, dispatch}) {
      if (dispatch && this.task.isHoldAutoTask ||
        hold && !this.task.isHoldAutoTask && !this.task.isDispatchAutoTask) {
        return ' [space]'
      }
      return ''
    },
    autoTask () {
      if (this.task.isHoldAutoTask) {
        this.task.isHoldAutoTask = false
        this.task.isDispatchAutoTask = true
      } else if (this.task.isDispatchAutoTask) {
        this.task.isHoldAutoTask = false
        this.task.isDispatchAutoTask = false
      } else {
        this.task.isHoldAutoTask = true
      }
    },
    onHold () {
      if (this.task.isDispatchAutoTask && this.task.isHoldAutoTask) {
        this.task.isDispatchAutoTask = false
      }
    },
    onDispatch () {
      if (this.task.isDispatchAutoTask && this.task.isHoldAutoTask) {
        this.task.isHoldAutoTask = false
      }
    },
    checkTaskForm () {
      this.$nextTick(() => {
        this.task.isValid = this.$refs.taskForm.isValid()
      })
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
        this.task.isHoldAutoTask = false
        this.task.isDispatchAutoTask = false
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
    $margin: 2px;
    margin: $margin;
    width: 100%;
    height: 100%;
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
