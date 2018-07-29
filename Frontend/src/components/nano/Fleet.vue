<template>
  <span class="fleet">
    <template v-if="fleet">
      <Planet @goToCell="goToCell" :id="fleet.from"></Planet>
      <span class="mdi mdi-arrow-right mdi-16px" />
      <Planet @goToCell="goToCell" :id="fleet.to"></Planet>
      <span title="Steps left" v-if="fleet.stepsLeft !== 0">/ {{ fleet.stepsLeft }}</span>
      <span title="Ships count">
        <span class="mdi mdi-rocket mdi-16px">{{ fleet.count }}<span v-if="fleet.damage" class="text-fail">-{{ fleet.damage }}</span></span>
      </span>
    </template>
    <span v-else>
      Loading...
    </span>
  </span>
</template>

<script>
import Planet from './Planet'

export default {
  name: 'Fleet',
  props: {
    fleet: Object
  },
  components: { Planet },
  methods: {
    goToCell (cellID) {
      this.$emit('goToCell', cellID)
    }
  }
}
</script>
