<template>
  <div class="active-buttons flex-horizontal">
    <template v-if="isCreator">
      <span class="button" @click="start"
        :class="startBtnClass">{{ $t('Start') }}</span>
      <span class="button" @click="regenerateMap" :class="regenBtnClass"
        :title="$t('Regenerate map')">{{ $t('Regen') }}</span>
    </template>
    <span class="button" @click="logout">
      {{ $t('Exit') }}
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
      sync: 'sync',
      players: 'members'
    }),
    regenBtnClass () {
      return this.sync.planets ? '' : 'disabled'
    },
    startBtnClass () {
      return this.canStart ? '' : 'disabled'
    },
    canStart () {
      return this.sync.game && this.sync.profile && this.sync.members &&
        this.isCreator && Object.keys(this.players).length >= 2
    }
  },
  methods: {
    start () {
      if (this.canStart) {
        if (this.$store.dispatch('game/start')) {
          this.$store.dispatch('syncUnset', 'game')
        }
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
        this.$toast(this.$t('Map isn\'t regenerated'))
      }
    },
    logout () {
      this.$refs.loader.show()
      this.$store.dispatch('logout').then(() => {
        this.$router.push({
          name: 'GamesList'
        })
      }).catch(err => {
        this.$router.push({
          name: 'GamesList'
        })
        this.$toast(this.$t(err.message))
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
