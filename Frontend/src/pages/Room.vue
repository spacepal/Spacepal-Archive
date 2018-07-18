<template>
  <div class="room-page">
    <div class="map-field">
      <Map></Map>
    </div>
    <div>
      <ActionButtons></ActionButtons>
      <GameInfo />
      <Members />
    </div>
  </div>
</template>

<script>
import Map from '../components/Map'
import GameInfo from '../components/GameInfo'
import Members from '../components/Members'
import ActionButtons from '../components/RoomActionButtons'

export default {
  name: 'Room',
  components: { GameInfo, Map, Members, ActionButtons },
  data () {
    return {
    }
  }
}
</script>

<style lang="scss">
.room-page {
  display: grid;
  grid-template-columns: auto 300px;
}
.map-field {
  $margin: 10px;
  max-width: calc(100% - #{$margin});
  max-height: calc(100% - #{$margin});
  display: flex;
  justify-content: center;
  align-items: center;
  margin: $margin;
}
</style>
