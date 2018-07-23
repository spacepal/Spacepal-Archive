<template>
  <div class="has-spinner" :class="loadingClass">
    <div v-if="this.adoptedFleets.length > 0" class="tasks">
      <template>
        <span>From</span>
        <span>To</span>
        <span>Player</span>
        <span>Count</span>
        <span>Steps</span>
        <span>
          <template v-if="canDelete">
            Action
          </template>
        </span>
      </template>
      <template v-for="fleet in adoptedFleets">
        <Planet :id="fleet.from" :key="fleet.id + '_1'" @goToCell="goToCell"></Planet>
        <Planet :id="fleet.to" :key="fleet.id + '_2'" @goToCell="goToCell"></Planet>
        <Member :key="fleet.id + '_3'" :planetID="fleet.to"></Member>
        <span :key="fleet.id + '_4'">
          {{ fleet.count }}
          <span class="mdi mdi-earth" v-if="fleet.hold"></span>
          <span class="mdi mdi-arrow-up" v-if="fleet.dispatch"></span>
        </span>
        <span :key="fleet.id + '_5'">
          {{ fleet.stepsLeft }}
        </span>
        <span :key="fleet.id + '_6'">
          <template v-if="canDelete">
            <a v-if="actionEnabled" @click="del(fleet.id)">delete</a>
            <span v-else>no</span>
          </template>
        </span>
      </template>
    </div>
    <p v-else>
      <slot name="noFleets">No fleets</slot>
    </p>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import Member from './nano/Member'
import Planet from './nano/Planet'

export default {
  name: 'Fleets',
  props: {
    fleets: Object,
    syncs: Array,
    canDelete: Boolean,
    lockAction: {
      type: Boolean,
      default: true
    }
  },
  data () {
    return {
    }
  },
  components: { Member, Planet },
  methods: {
    goToCell (cellID) {
      this.$emit('goToCell', cellID)
    },
    del (id) {
      this.$emit('delete', id)
    }
  },
  computed: {
    ...mapGetters({
      sync: 'sync',
      isLocked: 'isLocked'
    }),
    actionEnabled () {
      return !this.isLocked || this.lockAction === false
    },
    adoptedFleets () {
      let t = []
      for (let id in this.fleets) {
        let f = this.fleets[id]
        f.id = id
        t.push(f)
      }
      return t
    },
    loadingClass () {
      let isSynced = true
      this.syncs.forEach((sync) => {
        isSynced &= this.sync[sync]
      })
      return isSynced ? '' : 'loading'
    }
  }
}
</script>

<style lang="scss" scoped>
.tasks {
  display: grid;
  min-height: 100%;
  grid-template-columns: auto auto auto auto auto auto
}
.tasks > * {
  margin: 5px 20px;
  text-align: center
}
</style>
