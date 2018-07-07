<template>
  <span :style="memberInfo.style">
    <span class="mdi" :class="memberInfo.icon"></span>
    <span>{{ memberInfo.username }}</span>
  </span>
</template>

<script>
import { mapGetters } from 'vuex'
import Colors from '../../common/Colors'

const ICO_PLAYER = 'mdi-account'
const ICO_AI = 'mdi-desktop-classic'

export default {
  name: 'Member',
  props: {
    id: Number,
    planetID: Number
  },
  computed: {
    ...mapGetters(['member', 'planetByID']),
    memberID () {
      if (this.id) {
        return this.id
      }
      let p = this.planetByID(this.planetID)
      if (p) {
        return p.ownerID
      }
    },
    memberInfo () {
      let isArtificialIntelligence = false
      let username = 'neutral'
      let color = Colors['neutral'].bg
      let m = this.member(this.memberID)
      if (m) {
        ({ username, color, isArtificialIntelligence } = m)
        color = Colors[color].bg
      }
      return {
        style: { color },
        username,
        icon: isArtificialIntelligence ? ICO_AI : ICO_PLAYER
      }
    }
  }
}
</script>
