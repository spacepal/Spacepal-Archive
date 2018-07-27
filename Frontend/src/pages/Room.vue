<template>
  <div>
    <div class="loop_header"></div>
    <Map full :offsetX="280"></Map>
    <div class="info-field">
      <div class="info-panel-body">
        <ActionButtons></ActionButtons>
        <GameInfo />
        <Members />
      </div>
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
.info-field {
  position: absolute;
  right: 0;
  min-height: 100%;
  display: flex;
  .info-panel-body {
    flex: 1;
    display: flex;
    padding: 10px;
    flex-direction: column;
  }
  .info-panel-body > * {
    width: 320px;
  }
}
</style>
