<template>
  <a @click="goToCell">
    <span :style="planet.style" class="mdi mdi-earth"></span>
    <span>{{ planet.cellID }}</span>
  </a>
</template>

<script>
import { mapGetters } from 'vuex'
import Colors from '../../common/Colors'

export default {
  name: 'Planet',
  props: {
    id: Number
  },
  computed: {
    ...mapGetters(['member', 'planetByID']),
    planet () {
      let p = this.planetByID(this.id)
      let cellID = 0
      let color = Colors['neutral'].bg
      if (p) {
        cellID = p.cellID
        let m = this.member(p.ownerID)
        if (m) {
          color = Colors[m.color].bg
        }
      }
      return {
        cellID,
        style: { color }
      }
    }
  },
  methods: {
    goToCell () {
      let { cellID } = this.planet
      if (cellID && cellID !== 0) {
        this.$emit('goToCell', cellID)
      }
    }
  }
}
</script>
