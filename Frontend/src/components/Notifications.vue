<template>
  <div class="has-spinner" :class="loadingClass">
    <div v-if="events" class="notifications">
      <template v-for="n in notifications">
        <a :key="n.id + '_1'" @click="goToCell(n.cellID)">
          <span class="mdi mdi-earth" :style="n.style"></span>
          <span>{{ n.cellID }}</span>
        </a>
        <span :key="n.id + '_2'">{{ n.message }}</span>
        <span :key="n.id + '_3'">
          <span class="mdi mdi-desktop-classic"
            :style="n.style" v-if="n.isArtificialIntelligence">
            {{ n.member.username }}
          </span>
          <span class="mdi mdi-account" :style="n.style" v-else>
            {{ n.member.username }}
          </span>
        </span>
      </template>
    </div>
    <p v-else>No notifications</p>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import Colors from '../common/Colors'

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
  computed: {
    ...mapGetters({
      events: 'events/all',
      planetByID: 'planetByID',
      members: 'member',
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
      let cellID = 0
      let p = this.planetByID(event.target)
      if (p) cellID = p.cellID || cellID
      let color = Colors['neutral'].bg
      let username = 'unknown'
      let isArtificialIntelligence = false
      let m = this.members(event.member)
      if (m) {
        color = Colors[m.color].bg
        username = m.username
        isArtificialIntelligence = m.isArtificialIntelligence
      }
      let message = MESSAGES[event.type] || MESSAGES['UNKNOWN']
      return {
        id: this.counter++,
        cellID,
        style: { color },
        message,
        member: {
          username,
          isArtificialIntelligence
        }
      }
    },
    planetCellID (event) {
      return this.planetByID(event.target).cellID
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
