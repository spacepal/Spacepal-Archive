<template>
  <span>
    <template v-if="fleet">
      <Planet @goToCell="goToCell" :id="fleet.from"></Planet>
      <span class="mdi mdi-arrow-right mdi-16px" />
      <Planet @goToCell="goToCell" :id="fleet.to"></Planet>
      <span title="Steps left">/ {{ fleet.stepsLeft }}</span>
      <span title="Ships count">
        <span class="mdi mdi-rocket mdi-16px">{{ fleet.count }}</span>
      </span>
    </template>
    <span v-else>
      Loading...
    </span>
  </span>
</template>

<script>
import Planet from './Planet'
import { mapGetters } from 'vuex'

export default {
  name: 'Fleet',
  props: {
    id: Number
  },
  components: { Planet },
  computed: {
    ...mapGetters({
      fleets: 'fleets/all'
    }),
    fleet () {
      return this.fleets[this.id]
    }
  },
  methods: {
    goToCell (cellID) {
      this.$emit('goToCell', cellID)
    }
  }
}
</script>
