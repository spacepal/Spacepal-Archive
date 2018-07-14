<template>
  <div class="active-buttons flex-horizontal">
    <template v-if="isAdmin && isRoom">
      <span class="button" @click="start">Start</span>
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
      profile: 'profile',
      isLoggedIn: 'isPlayer',
      isRoom: 'game/isRoom',
      isGame: 'game/isGame',
      isLocked: 'isLocked',
      sync: 'sync'
    }),
    isAdmin () {
      return this.profile.isCreator
    },
    regenBtnClass () {
      return this.sync.planets ? '' : 'disabled'
    }
  },
  methods: {
    start () {
      console.warn('ActionButtons.vue: @todo start()')
    },
    endTurn () {
      this.$store.dispatch('game/endTurn')
    },
    regenerateMap () {
      if (!this.sync.planets || !this.$store.dispatch('shuffleMap')) {
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
