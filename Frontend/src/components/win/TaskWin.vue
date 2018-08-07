<template>
  <div>
    <Window type="confirm" ref="taskWindow" :title="$t('Create task')"
      @confirm="success" @close="close" :enabled="isValid">
      <Form ref="taskForm" class="withoutborder">
        <TextInput type="number" :autoSelect="true"
          :label="taskLabel" :force="true"
          :min="(task.isHoldAutoTask ? 0 : 1)"
          :max="(isAutoTask ? Number.MAX_VALUE : task.maxCount)"
          v-model="task.count"
          @change="checkTaskForm"></TextInput>
        <div class="flex-horizontal">
          <SwitchBox :label="$t('Hold') + autoTaskLabel({hold: true, dispatch: false})"
            :title="$t('Create autotask that hold ships on the planet')"
            v-model="task.isHoldAutoTask"
            @change="onHold(); checkTaskForm()" />
          <SwitchBox :label="$t('Dispatch') + autoTaskLabel({hold: false, dispatch: true})"
            :title="$t('Create autotask that dispatch ships from the planet')"
            v-model="task.isDispatchAutoTask"
            @change="onDispatch(); checkTaskForm()" />
        </div>
      </Form>
    </Window>
  </div>
</template>

<script>
import Window from '../Window'
import TextInput from '../TextInput'
import Form from '../Form'
import SwitchBox from '../SwitchBox'

export default {
  name: 'TaskWin',
  data () {
    return {
      task: { },
      isValid: false,
      hotKeys: [
        {
          code: 'Space',
          method: this.autoTask,
          modalEnabled: true
        }
      ]
    }
  },
  components: { Window, TextInput, Form, SwitchBox },
  computed: {
    isAutoTask () {
      return this.task.isHoldAutoTask || this.task.isDispatchAutoTask
    },
    taskLabel () {
      let count = this.task.maxCount
      if (this.task.isHoldAutoTask) {
        count -= this.task.count
      }
      count = Math.max(count || 0, 0)
      return `${this.$t('Ships')}: ${count}`
    }
  },
  methods: {
    show (task) {
      this.task = task
      this.$refs.taskWindow.show()
    },
    close () {
      this.$emit('close')
    },
    success () {
      if (this.isValid) {
        this.$emit('confirm', this.task)
      }
    },
    autoTaskLabel ({ hold, dispatch }) {
      if ((dispatch && this.task.isHoldAutoTask) ||
        (hold && !this.task.isHoldAutoTask && !this.task.isDispatchAutoTask)) {
        return this.$t('keySpace')
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
        this.isValid = this.$refs.taskForm.isValid()
      })
    }
  }
}
</script>
