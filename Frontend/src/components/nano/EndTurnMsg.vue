<template>
  <div class="turn-number-bg" v-show="isShowed">
    <div class="circle">
      <div class="turn-number">{{turn}}</div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
export default {
  name: 'EndTurnMsg',
  data () {
    return {
      isShowed: false
    }
  },
  computed: {
    ...mapGetters({
      game: 'game/info',
      sync: 'sync'
    }),
    turn () {
      let t = this.game.turnNumber
      if (t > 9999) {
        t = Math.ceil(t / 10000)
        return t + 'k'
      }
      return t
    }
  },
  mounted () {
    this._unwatch = this.$store.watch((_, getters) => getters.sync.game, () => {
      if (!this.sync['endTurn'] || !this.sync['game']) {
        return
      }
      this.$store.dispatch('syncUnset', 'endTurn')
      clearTimeout(this._timer)
      this._timer = setTimeout(() => {
        this.isShowed = false
      }, 1000)
      this.isShowed = true
      this.$emit('onTurnEnded')
    })
  },
  beforeDestroy () {
    this._unwatch()
  }
}
</script>

<style lang="scss" scoped>
@import '../../css/components/_end_turn_msg.scss';
</style>
