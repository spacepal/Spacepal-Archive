<template>
  <div>
    <div class="loop_header"></div>
    <Map full :offsetX="280" ref="map"></Map>
    <div class="info-field">
      <div class="info-panel-body">
        <ActionButtons ref="actions"></ActionButtons>
        <GameInfo />
        <Members ref="members" />
      </div>
    </div>
    <HelpPanel ref="help" name="Room" :data="helpData" :refs="$refs" />
  </div>
</template>

<script>
import Map from '../components/Map'
import GameInfo from '../components/GameInfo'
import Members from '../components/Members'
import ActionButtons from '../components/RoomActionButtons'
import HelpPanel from '../components/HelpPanel.vue'
import { mapGetters } from 'vuex';

export default {
  name: 'Room',
  components: { GameInfo, Map, Members, ActionButtons, HelpPanel },
  data () {
    return {
    }
  },
  computed: {
    ...mapGetters([
      'isCreator'
    ]),
    helpData () {
      return {
        isCreator: this.isCreator
      }
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
