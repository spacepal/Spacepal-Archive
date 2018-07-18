<template>
  <div class="game-page">
    <Map ref="map" full></Map>
    <div class="info-panel-bg"
      v-if="panelsVisibility.main"
      @click="hideAllPanels">
      <Form class="info-panel-body">
        <Members class="withoutborder" />
        <GameInfo class="withoutborder" />
      </Form>
    </div>
    <div class="info-panel-bg"
      v-if="panelsVisibility.tasks"
      @click.self="hideAllPanels">
      <Form class="info-panel-body" @click="false">
        <Tasks @goToCell="goToCell"></Tasks>
      </Form>
    </div>
    <div class="info-panel-bg"
      v-if="panelsVisibility.notifications"
      @click="hideAllPanels">
      <Form class="info-panel-body">
        <Notifications @goToCell="goToCell" />
      </Form>
    </div>
    <GameMenu @showPanel="showPanel" @goHome="goHome" />
  </div>
</template>

<script>
import Map from '../components/Map'
import Form from '../components/Form'
import GameInfo from '../components/GameInfo'
import Members from '../components/Members'
import Notifications from '../components/Notifications'
import Tasks from '../components/Tasks'
import GameMenu from '../components/GameMenu'

export default {
  name: 'Play',
  components: {
    GameInfo,
    GameMenu,
    Map,
    Members,
    Form,
    Notifications,
    Tasks
  },
  data () {
    return {
      hotKeys: [
        {
          code: 'KeyQ',
          method: () => {
            this.panelsVisibility.main = false
          },
          methodDown: () => {
            this.hideAllPanels('info')
            this.panelsVisibility.main = true
          },
          description: 'Show game info'
        },
        {
          code: 'KeyT',
          method: () => {
            this.hideAllPanels('tasks')
            this.panelsVisibility.tasks ^= true
          },
          description: 'Show tasks'
        },
        {
          code: 'KeyN',
          method: () => {
            this.hideAllPanels('notifications')
            this.panelsVisibility.notifications ^= true
          },
          description: 'Show notifications'
        },
        {
          code: 'Space',
          method: this.endTurn,
          description: 'End turn'
        },
        {
          code: 'Escape',
          method: this.hideAllPanels
        }
      ],
      panelsVisibility: {
        main: false,
        tasks: false,
        notifications: false
      }
    }
  },
  methods: {
    showPanel (panelName) {
      this.hideAllPanels()
      this.panelsVisibility[panelName] = true
    },
    goHome () {
      this.$refs.map.goHome()
    },
    goToCell (cellID) {
      this.$refs.map.goToCell(cellID)
    },
    endTurn () {
      if (this.$store.getters.isLocked) {
        this.$toast('You cannot end turn now')
      } else {
        this.$store.dispatch('game/endTurn')
      }
    },
    hideAllPanels (except = '') {
      for (let k in this.panelsVisibility) {
        if (k === except) {
          continue
        }
        this.panelsVisibility[k] = false
      }
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
