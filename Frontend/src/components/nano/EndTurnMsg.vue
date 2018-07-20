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
  methods: {
    mounted () {
      this.$store.watch((_, getters) => getters['game/info'], () => {
        if (!this.sync['endTurn']) {
          return
        }
        this.$store.dispatch('syncReset', 'endTurn')
        clearTimeout(this._timer)
        this._timer = setTimeout(() => {
          this.isShowed = false
        }, 600)
        this.isShowed = true
      })
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../../css/components/_end_turn_msg.scss';
</style>
