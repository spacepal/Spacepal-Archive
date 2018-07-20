<template>
  <div>
    <div class="button" @click="show">On</div>
    <EndTurnMsg ref="endTurn"></EndTurnMsg>
  </div>
</template>

<script>
import EndTurnMsg from './nano/EndTurnMsg'

export default {
  name: 'Test',
  components: {
    EndTurnMsg
  },
  methods: {
    show (turn) {
      this.$refs.endTurn.show(31)
    }
  }
}
</script>
