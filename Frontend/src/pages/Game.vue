<template>
  <div>
    <Room v-if="isRoom" />
    <Play v-if="isGame" />
    <End v-if="isOver" />
    <FullPreloader autostart v-if="isUnknown" ref="loader" />
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import Play from './Play'
import Room from './Room'
import End from './End'
import FullPreloader from '../components/FullPreloader'

export default {
  name: 'Game',
  components: {
    Play,
    Room,
    End,
    FullPreloader
  },
  computed: {
    ...mapGetters({
      isRoom: 'game/isRoom',
      isGame: 'game/isGame',
      isOver: 'game/isOver',
      isUnknown: 'game/isUnknown'
    })
  }
}
</script>
