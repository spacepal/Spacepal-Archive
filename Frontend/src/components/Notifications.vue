<template>
  <div class="has-spinner" :class="loadingClass">
    <div v-if="notifications.length > 0" class="notifications">
      <template v-for="n in notifications">
        <Planet :key="n.id + '_1'" @goToCell="goToCell" :id="n.target"></Planet>
        <span :key="n.id + '_2'">{{ n.message }}</span>
        <Member :key="n.id + '_3'" :id="n.member"></Member>
      </template>
    </div>
    <p v-else>No notifications</p>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import Member from './nano/Member'
import Planet from './nano/Planet'

const MESSAGES = {
  PLANET_LOST: 'The planet is lost',
  PLANET_SAVED: 'The planet is saved',
  ATTACK_FAILED: 'The attack is repelled',
  ATTACK_SUCCESS: 'The attack is succeeded',
  UNKNOWN: 'Unknow event'
}

export default {
  name: 'Events',
  data () {
    return {
      counter: 0
    }
  },
  components: { Planet, Member },
  computed: {
    ...mapGetters({
      events: 'events/all',
      sync: 'sync'
    }),
    loadingClass () {
      return this.sync.events &&
        this.sync.planets &&
        this.sync.members
        ? '' : 'loading'
    },
    notifications () {
      return this.events.map(this.notification)
    }
  },
  methods: {
    goToCell (cellID) {
      this.$emit('goToCell', cellID)
    },
    notification (event) {
      return {
        id: this.counter++,
        target: event.target,
        message: MESSAGES[event.type] || MESSAGES['UNKNOWN'],
        member: event.member
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.notifications {
  display: grid;
  min-height: 100%;
  grid-template-columns: auto auto auto
}
.notifications > span {
  margin: 5px 20px
}
</style>
