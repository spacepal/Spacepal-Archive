<template>
  <div class="has-spinner" :class="loadingClass">
    <div v-if="this.adoptedTasks.length > 0" class="tasks">
      <span>From</span><span>To</span><span>Player</span><span>Count</span><span>Action</span>
      <template v-for="task in adoptedTasks">
        <Planet :id="task.from" :key="task.id + '_1'" @goToCell="goToCell"></Planet>
        <Planet :id="task.to" :key="task.id + '_2'" @goToCell="goToCell"></Planet>
        <Member :key="task.id + '_3'" :planetID="task.to"></Member>
        <span :key="task.id + '_4'">
          {{ task.count }}
        </span>
        <span :key="task.id + '_5'">
          <a v-if="!isLocked" @click="deleteTask(task.id)">delete</a>
          <span v-else>no</span>
        </span>
      </template>
    </div>
    <p v-else>No tasks</p>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import Member from './nano/Member'
import Planet from './nano/Planet'

export default {
  name: 'Tasks',
  data () {
    return {
    }
  },
  components: { Member, Planet },
  methods: {
    goToCell (cellID) {
      this.$emit('goToCell', cellID)
    },
    deleteTask (taskID) {
      this.$store.dispatch('tasks/del', taskID)
    }
  },
  computed: {
    ...mapGetters({
      tasks: 'tasks/all',
      sync: 'sync',
      isLocked: 'isLocked'
    }),
    adoptedTasks () {
      let t = []
      for (let taskID in this.tasks) {
        let task = this.tasks[taskID]
        task.id = taskID
        t.push(task)
      }
      return t
    },
    loadingClass () {
      return this.sync.planets && this.sync.members ? '' : 'loading'
    }
  }
}
</script>

<style lang="scss" scoped>
.tasks {
  display: grid;
  min-height: 100%;
  grid-template-columns: auto auto auto auto auto
}
.tasks > * {
  margin: 5px 20px;
  text-align: center
}
</style>
