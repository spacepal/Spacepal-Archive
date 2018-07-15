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
const ICO_ADMIN = 'mdi-account-settings-variant'

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
      let isCreator = false
      let username = (this.id === -1 ? 'loading...' : 'neutral')
      let color = Colors['neutral'].bg
      let m = this.member(this.memberID)
      if (m) {
        ({ username, color, isArtificialIntelligence, isCreator } = m)
        if (Colors[color] !== undefined) {
          color = Colors[color].bg
        }
      }
      let icon = ICO_PLAYER
      if (isArtificialIntelligence) {
        icon = ICO_AI
      } else if (isCreator) {
        icon = ICO_ADMIN
      }
      return {
        style: { color },
        username,
        icon
      }
    }
  }
}
</script>
