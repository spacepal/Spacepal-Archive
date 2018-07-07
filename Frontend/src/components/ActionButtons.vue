<template>
  <div class="active-buttons flex-horizontal">
    <template v-if="isAdmin && isRoom">
      <span class="button" @click="start">Start</span>
      <span class="button" @click="regenerateMap">Regen</span>
    </template>
    <span class="button" v-if='!isLocked' @click="endTurn">End turn</span>
    <span class="button" @click="logout">
      <template v-if="isGame">
        Throw in the towel
      </template>
      <template v-if="isRoom">
        Logout
      </template>
      <template v-if="!isGame && !isRoom">
        Exit
      </template>
    </span>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  name: 'ActionButtons',
  computed: {
    ...mapGetters({
      profile: 'profile',
      isLoggedIn: 'isPlayer',
      isRoom: 'game/isRoom',
      isGame: 'game/isGame',
      isLocked: 'isLocked'
    }),
    isAdmin () {
      return this.profile.isCreator
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
      console.warn('ActionButtons.vue: @todo regenerateMap()')
    },
    logout () {
      this.$store.dispatch('logout').catch(err => {
        this.$toast(err.message)
      })
      this.$router.push({
        name: 'GamesList'
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
