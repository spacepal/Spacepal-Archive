<template>
  <div class="has-spinner" :class="loadingClass">
    <div v-if="notifications.length > 0" class="notifications">
      <template v-for="n in notifications">
        <p :key="n.id" v-if="n.type === 'PLANET_LOST'">
          <span class="mdi mdi-security-close mdi-16px text-fail"></span>
          Planet <Planet @goToCell="goToCell" :id="n.target"></Planet>
          is lost. Agressor:
          <Member :id="n.member"></Member>
        </p>
        <p :key="n.id" v-if="n.type === 'PLANET_SAVED'">
          <span class="mdi mdi-security mdi-16px text-success"></span>
          Planet <Planet @goToCell="goToCell" :id="n.target"></Planet>
          is saved. Agressor:
          <Member :id="n.member"></Member>
        </p>
        <p :key="n.id" v-if="n.type === 'ATTACK_FAILED'">
          <span class="mdi mdi-target mdi-16px text-fail"></span>
          Attack to <Planet @goToCell="goToCell" :id="n.target"></Planet>
          <Member :id="n.member"></Member> is failed
        </p>
        <p :key="n.id" v-if="n.type === 'ATTACK_SUCCESS'">
          <span class="mdi mdi-target mdi-16px text-success"></span>
          Attack to <Planet @goToCell="goToCell" :id="n.target"></Planet>
          <Member :id="n.member"></Member> is succeeded
        </p>
        <p :key="n.id" v-if="n.type === 'PIRATES_DAMAGED_PLANET'">
          <span class="mdi mdi-pirate mdi-16px text-fail"></span>
          Planet
          <Planet @goToCell="goToCell" :id="n.target"></Planet>
          is damaged by pirates
        </p>
        <p :key="n.id" v-if="n.type === 'PIRATES_DAMAGED_FLEET'">
          <span class="mdi mdi-skull mdi-16px text-fail"></span>
          Fleet
          <Fleet  @goToCell="goToCell" :id="n.target" />
          is damaged by pirates
        </p>
        <p :key="n.id" v-if="n.type === 'PLAYER_LOST'">
          <span class="mdi mdi-account-off mdi-16px text-success"></span>
          Player
          <Member :id="n.member"></Member>
          lost
        </p>
        <p :key="n.id" v-if="n.type === 'FLEET_LAND'">
          <span class="mdi mdi-airplane-landing mdi-16px text-success"></span>
          Fleet to
          <planet :id="n.target"></planet>
          is landed
        </p>
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
  PIRATES_DAMAGED_FLEET: 'Fleet damaged by pirates',
  PLAYER_LOST: `Player lost`,
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
      console.log(event.type)
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
</style>
