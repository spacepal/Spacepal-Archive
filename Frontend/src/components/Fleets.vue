<template>
  <div class="has-spinner" :class="loadingClass">
    <div v-if="this.adoptedTasks.length > 0" class="fleets">
      <span>From</span><span>To</span><span>Player</span><span>Count</span>
      <template v-for="fleet in adoptedFleets">
        <Planet :id="fleet.from" :key="fleet.id + '_1'" @goToCell="goToCell"></Planet>
        <Planet :id="fleet.to" :key="fleet.id + '_2'" @goToCell="goToCell"></Planet>
        <Member :key="fleet.id + '_3'" :planetID="fleet.to"></Member>
        <span :key="fleet.id + '_4'">
          {{ fleet.count }}
        </span>
        <span :key="fleet.id + '_5'">
          <a v-if="!isLocked" @click="deleteTask(fleet.id)">delete</a>
          <span v-else>no</span>
        </span>
      </template>
    </div>
    <p v-else>No Fleets</p>
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
    }
  },
  computed: {
    ...mapGetters({
      fleets: 'fleets/all',
      sync: 'sync'
    }),
    adoptedFleets () {
      let f = []
      for (let taskID in this.fleets) {
        let fleet = this.fleets[taskID]
        fleet.id = taskID
        f.push(fleet)
      }
      return f
    },
    loadingClass () {
      return tthis.sync.fleets ? '' : 'loading'
    }
  }
}
</script>

<style lang="scss" scoped>
.fleets {
  display: grid;
  min-height: 100%;
  grid-template-columns: auto auto auto auto auto
}
.fleets > * {
  margin: 5px 20px;
  text-align: center
}
</style>
