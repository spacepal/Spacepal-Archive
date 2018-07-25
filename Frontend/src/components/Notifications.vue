<template>
  <div class="has-spinner" :class="loadingClass">
    <div v-if="notifications.length > 0" class="notifications">
      <template v-for="n in notifications">
        <template v-if="n.type in ['PLANET_LOST', 'PLANET_SAVED', 'ATTACK_FAILED', 'ATTACK_SUCCESS']">
          <Planet :key="n.id + '_1'" @goToCell="goToCell" :id="n.target"></Planet>
          <span :key="n.id + '_2'">{{ n.message }}</span>
          <Member :key="n.id + '_3'" :id="n.member"></Member>
        </template>
        <template v-if="n.type in ['PIRATES_DAMAGED_PLANET', 'FLEET_LAND']">
          <Planet :key="n.id + '_1'" @goToCell="goToCell" :id="n.target"></Planet>
          <span :key="n.id + '_2'" class="span-1-2">{{ n.message }}</span>
        </template>
        <template v-if="n.type == 'PIRATES_DAMAGED_FLEET'">
          <Fleet  @goToCell="goToCell" :id="n.target" :key="n.id + '_1'" />
          <span :key="n.id + '_2'" class="span-1-2">{{ n.message }}</span>
        </template>
        <template v-if="n.type === 'PLAYER_LOST'">
          <Member :key="n.id + '_1'" :id="n.member"></Member>
          <span :key="n.id + '_2'" class="span-1-2">{{ n.message }}</span>
        </template>
      </template>
    </div>
    <p v-else>No notifications</p>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import Member from './nano/Member'
import Planet from './nano/Planet'
import Fleet from './nano/Fleet'

const MESSAGES = {
  PLANET_LOST: 'The planet is lost',
  PLANET_SAVED: 'The planet is saved',
  ATTACK_FAILED: 'The attack is repelled',
  ATTACK_SUCCESS: 'The attack is succeeded',
  PIRATES_DAMAGED_PLANET: 'Damage by pirates',
  PIRATES_DAMAGED_FLEET: 'Damage by pirates',
  PLAYER_LOST: 'Player lost',
  FLEET_LAND: 'Fleet landed',
  UNKNOWN: 'Unknow event'
}

export default {
  name: 'Events',
  data () {
    return {
      counter: 0
    }
  },
  components: { Planet, Member, Fleet },
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
        member: event.member,
        type: event.type
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
.span-1-2 {
  grid-column: 1, 2;
}
</style>
