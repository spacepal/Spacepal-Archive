<template>
  <div class="has-spinner" :class="loadingClass">
    <div v-if="notifications.length > 0" class="notifications">
      <template v-for="n in notifications">
        <p :key="n.id" v-if="n.type === 'PLANET_LOST'">
          <span class="mdi mdi-security-close mdi-16px text-fail"></span>
          The planet <Planet @goToCell="goToCell" :id="n.target"></Planet>
          has lost. Agressor:
          <Member :id="n.member"></Member>
        </p>
        <p :key="n.id" v-if="n.type === 'PLANET_SAVED'">
          <span class="mdi mdi-security mdi-16px text-success"></span>
          The planet <Planet @goToCell="goToCell" :id="n.target"></Planet>
          has been saved. Agressor:
          <Member :id="n.member"></Member>
        </p>
        <p :key="n.id" v-if="n.type === 'ATTACK_FAILED'">
          <span class="mdi mdi-target mdi-16px text-fail"></span>
          Attack to <Planet @goToCell="goToCell" :id="n.target"></Planet>
          <Member :id="n.member"></Member> was failed
        </p>
        <p :key="n.id" v-if="n.type === 'ATTACK_SUCCESS'">
          <span class="mdi mdi-target mdi-16px text-success"></span>
          Attack on the planet <Planet @goToCell="goToCell" :id="n.target"></Planet>
          <Member :id="n.member"></Member> was successful
        </p>
        <p :key="n.id" v-if="n.type === 'PIRATES_DAMAGED_PLANET'">
          <span class="mdi mdi-pirate mdi-16px text-fail"></span>
          The planet
          <Planet @goToCell="goToCell" :id="n.target"></Planet>
          has been damaged by pirates
        </p>
        <p :key="n.id" v-if="n.type === 'PIRATES_DAMAGED_FLEET'">
          <span class="mdi mdi-skull mdi-16px text-fail"></span>
          Pirates has attacked fleet
          <Fleet @goToCell="goToCell" :fleet="n.fleet" />
        </p>
        <p :key="n.id" v-if="n.type === 'PLAYER_LOST'">
          <span class="mdi mdi-account-off mdi-16px text-success"></span>
          The player
          <Member :id="n.member"></Member>
          has been lost
        </p>
        <p :key="n.id" v-if="n.type === 'FLEET_LAND'">
          <span class="mdi mdi-airplane-landing mdi-16px text-success"></span>
          The fleet <Fleet @goToCell="goToCell" :fleet="n.fleet" />
          has been landed.
        </p>
      </template>
    </div>
    <p v-else>Empty</p>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import Member from './nano/Member'
import Planet from './nano/Planet'
import Fleet from './nano/Fleet'

const EVENTS_PRIORITY = {
  PLANET_LOST: 1,
  PLANET_SAVED: 2,
  ATTACK_FAILED: 3,
  ATTACK_SUCCESS: 4,
  PIRATES_DAMAGED_PLANET: 5,
  PIRATES_DAMAGED_FLEET: 6,
  PLAYER_LOST: 7,
  FLEET_LAND: 8,
  UNKNOWN: 9
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
      return this.events.map(this.notification).sort((a, b) => {
        return a.priority - b.priority
      })
    }
  },
  methods: {
    goToCell (cellID) {
      this.$emit('goToCell', cellID)
    },
    notification (event) {
      let obj = {
        id: this.counter++,
        target: event.target,
        priority: EVENTS_PRIORITY[event.type] || 10,
        member: event.member,
        type: event.type
      }
      if (obj.type === 'FLEET_LAND' ||
        obj.type === 'PIRATES_DAMAGED_FLEET') {
        obj.fleet = event.fleet
      }
      return obj
    }
  }
}
</script>

<style lang="scss" scoped>
.notifications > p {
  white-space: nowrap;
}
</style>
