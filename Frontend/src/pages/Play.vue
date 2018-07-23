<template>
  <div class="game-page" ref="page">
    <Map ref="map" full @addBookmark="setBookmark" />
    <transition name="scale" mode="out-in">
      <div class="info-panel-bg"
        v-if="panelsVisibility.main"
        @click="hideAllPanels">
        <Form class="info-panel-body">
          <Members class="withoutborder" />
          <GameInfo class="withoutborder" />
        </Form>
      </div>
    </transition>
    <div class="info-panel-bg"
      v-if="panelsVisibility.tasks"
      @click="onPanelClicked($event, tasks)">
      <Form class="info-panel-body" @click="false">
        <Fleets
          :canDelete="true"
          :syncs="['planets', 'profile']"
          :fleets="tasks"
          @goToCell="goToCell"
          @delete="delTask">
          <template slot="noFleets">
            No tasks
          </template>
        </Fleets>
      </Form>
    </div>
    <div class="info-panel-bg"
      v-if="panelsVisibility.fleets"
      @click="onPanelClicked($event, fleets)">
      <Form class="info-panel-body" @click="false">
        <Fleets
          :canDelete="false"
          :syncs="['fleets']"
          :fleets="fleets"
          @goToCell="goToCell">
          <template slot="noFleets">
            No fleets
          </template>
        </Fleets>
      </Form>
    </div>
    <div class="info-panel-bg"
      v-if="panelsVisibility.autoTasks"
      @click.self="hideAllPanels"
      @click="onPanelClicked($event, autoTasks)">
      <Form class="info-panel-body" @click="false">
        <Fleets
          :canDelete="true"
          :syncs="[]"
          :fleets="autoTasks"
          @goToCell="goToCell"
          @delete="delTask"
          :lockAction="false">
          <template slot="noFleets">
            No auto tasks
          </template>
        </Fleets>
      </Form>
    </div>
    <div class="info-panel-bg"
      v-if="panelsVisibility.notifications"
      @click="onPanelClicked($event, notifications)">
      <Form class="info-panel-body">
        <Notifications @goToCell="goToCell" />
      </Form>
    </div>
    <div class="info-panel-bg"
      v-show="panelsVisibility.bookmarks"
      @click.self="hideAllPanels">
      <Form class="info-panel-body">
        <Bookmarks ref="bookmarks" @goToCell="goToCell" />
      </Form>
    </div>
    <GameMenu @showPanel="showPanel" @goHome="goHome" />
    <EndTurnMsg @onTurnEnded="onTurnEnded" />
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import Map from '../components/Map'
import Form from '../components/Form'
import GameInfo from '../components/GameInfo'
import Members from '../components/Members'
import Notifications from '../components/Notifications'
import Fleets from '../components/Fleets'
import GameMenu from '../components/GameMenu'
import EndTurnMsg from '../components/nano/EndTurnMsg'
import Bookmarks from '../components/Bookmarks'

export default {
  name: 'Play',
  components: {
    GameInfo,
    GameMenu,
    Map,
    Members,
    Form,
    Notifications,
    Fleets,
    EndTurnMsg,
    Bookmarks
  },
  data () {
    let hotKeys = [
      {
        code: 'KeyB',
        method: () => {
          this.hideAllPanels('bookmarks')
          this.panelsVisibility.bookmarks ^= true
        },
        description: 'Show bookmarks'
      },
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
        code: 'KeyF',
        method: () => {
          this.hideAllPanels('fleets')
          this.panelsVisibility.fleets ^= true
        },
        description: 'Show fleets'
      },
      {
        code: 'KeyA',
        method: () => {
          this.hideAllPanels('autoTasks')
          this.panelsVisibility.autoTasks ^= true
        },
        description: 'Show auto tasks'
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
        modalLock: true,
        description: 'End turn'
      },
      {
        code: 'Escape',
        method: this.hideAllPanels
      }
    ]

    return {
      hotKeys,
      panelsVisibility: {
        main: false,
        tasks: false,
        autoTasks: false,
        notifications: false,
        fleets: false,
        bookmarks: false
      }
    }
  },
  computed: {
    ...mapGetters({
      tasks: 'tasks/all',
      fleets: 'fleets/all',
      autoTasks: 'tasks/autoTasks',
      notifications: 'events/all'
    })
  },
  methods: {
    ...mapActions({
      delTask: 'tasks/del'
    }),
    setBookmark (planetID) {
      this.$refs.bookmarks.setBookmark(planetID)
    },
    onPanelClicked (event, data) {
      if ((data.length !== undefined && data.length === 0) ||
        Object.values(data).length === 0) {
        this.hideAllPanels()
      } else {
        event.preventDefault()
      }
    },
    onTurnEnded () {
      this.panelsVisibility['main'] = false
    },
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
        this.$toast('The turn is already ended')
      } else {
        this.showPanel('main')
        this.$store.dispatch('game/endTurn')
      }
    },
    hideAllPanels (except = '') {
      if (this.panelsVisibility.bookmarks) {
        this.$refs.bookmarks.resetSelection()
      }
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
