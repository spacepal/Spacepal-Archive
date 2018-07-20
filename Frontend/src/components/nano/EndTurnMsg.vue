<template>
  <div class="turn-number-bg" v-show="isShowed">
    <div class="circle">
      <div class="turn-number">{{turn}}</div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'EndTurnMsg',
  data () {
    return {
      isShowed: false,
      turn: 0
    }
  },
  methods: {
    show (turn) {
      clearTimeout(this._timer)
      this._timer = setTimeout(() => {
        this.isShowed = false
      }, 600)
      this.isShowed = true
      if (turn > 9999) {
        this.turn = Math.ceil(turn / 10000)
        this.turn += 'k'
      } else {
        this.turn = turn
      }
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../../css/components/_end_turn_msg.scss';
</style>
