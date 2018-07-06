<template>
  <div class="active-buttons flex-horizontal">
    <span class='button' v-if='isAdmin' @click="start">Start</span>
    <span class='button' v-if='canEndTurn' @click="endTurn">endTurn</span>
    <span class='button' @click="logout">
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
      isGame: 'game/isGame'
    }),
    isAdmin () {
      return this.profile.isCreator
    },
    canEndTurn () {
      return this.isGame &&
        !this.$state.getters['tasks/isLocked']
    }
  },
  methods: {
    start () {
      console.warn('ActionButtons.vue: @todo start()')
    },
    endTurn () {
      console.warn('ActionButtons.vue: @todo endTurn()')
    },
    logout () {
      this.$store.dispatch('logout').then(() => {
        this.$router.push({
          name: 'GamesList'
        })
      }).catch(err => {
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
