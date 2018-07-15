<template>
  <div class="active-buttons flex-horizontal">
    <template v-if="isCreator && isRoom">
      <span class="button" @click="start" :class="startBtnClass">Start</span>
      <span class="button" @click="regenerateMap" :class="regenBtnClass">Regen</span>
    </template>
    <span class="button" v-if='!isLocked' @click="endTurn">End turn</span>
    <span class="button" @click="logout">
      <template v-if="isGame">
        Throw in the towel
      </template>
      <template v-else>
        Exit
      </template>
    </span>
    <FullPreloader ref="loader" />
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import FullPreloader from './FullPreloader'

export default {
  name: 'ActionButtons',
  components: {
    FullPreloader
  },
  computed: {
    ...mapGetters({
      isCreator: 'isCreator',
      isLoggedIn: 'isPlayer',
      isRoom: 'game/isRoom',
      isGame: 'game/isGame',
      isLocked: 'isLocked',
      sync: 'sync'
    }),
    regenBtnClass () {
      return this.sync.planets ? '' : 'disabled'
    },
    startBtnClass () {
      return this.canStart ? '' : 'disabled'
    },
    canStart () {
      return this.sync.profile && this.isCreator &&
        this.sync.players && this.players.length >= 2
    }
  },
  methods: {
    start () {
      if (this.canStart) {
        this.$store.dispatch('game/start')
      }
    },
    endTurn () {
      this.$store.dispatch('game/endTurn')
    },
    regenerateMap () {
      if (!this.sync.planets) {
        return false
      }
      if (!this.$store.dispatch('shuffleMap')) {
        this.$toast('Map isn\'t regenerated')
      }
    },
    logout () {
      this.$refs.loader.show()
      this.$store.dispatch('logout').then(() => {
        this.$router.push({
          name: 'GamesList'
        })
      }).catch(err => {
        this.$refs.loader.hide()
        this.$toast(err.message)
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.active-buttons {
  margin: 10px 0;
}
</style>
