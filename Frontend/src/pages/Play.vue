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
      @click.self="hideAllPanels"
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
      @click.self="hideAllPanels"
      @click="onPanelClicked($event, fleets)">
      <Form class="info-panel-body">
        <Fleets
          :canDelete="false"
          :syncs="['fleets', 'planets']"
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
          :syncs="['planets']"
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
    <Window ref="quickStart" type="alert" title="Quick start">
      <template>
        <span class="quick-start-p">At the start of the game you have only one planet — your capital (press <span class="mdi mdi-keyboard mdi-24px splitter"></span>Home for quick goto).</span>
        <span class="quick-start-p">Besides it on the map are located neutral planets (peaceful) and planets of your opponents.</span>
        <span class="quick-start-p">You can attack another planet and captures it. The power of attack per ship depends on kill percentage (kill) of planet-sender.</span>
        <span class="quick-start-p">Every turn, count of ships on the planet is increased by production value (prod).</span>
        <span class="quick-start-p">If you conquer planets of other players — you will win.</span>
        <span class="quick-start-p">Press <span class="mdi mdi-keyboard mdi-24px splitter"></span>K for show all hotkeys</span>
        <span class="quick-start-btn"><SwitchBox v-model="quickStartDisabled" label="Don't show again" title="You can press KeyL for show quick start again" /></span>
      </template>
    </Window>
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
import Window from '../components/Window'
import SwitchBox from '../components/SwitchBox'
import GameMenu from '../components/GameMenu'
import EndTurnMsg from '../components/nano/EndTurnMsg'
import Bookmarks from '../components/Bookmarks'

const NOTIFICATION_ICON = 'https://avatars2.githubusercontent.com/u/41302202?s=400&v=4'

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
    Window,
    SwitchBox,
    EndTurnMsg,
    Bookmarks
  },
  watch: {
    quickStartDisabled (val) {
      this.$store.dispatch('setQuickStart', !val)
    }
  },
  data () {
    let hotKeys = [
      {
        code: 'KeyZ',
        ctrl: true,
        shift: true,
        method: () => {
          if (!this.forceAutoEndTurn) {
            this.endTurn()
          }
          this.forceAutoEndTurn ^= true
        },
        modalLock: true
      },
      {
        code: 'KeyL',
        method: () => {
          this.$refs.quickStart.show()
        },
        description: 'Quick start'
      },
      {
        code: 'KeyB',
        method: () => {
          this.hideAllPanels('bookmarks')
          this.panelsVisibility.bookmarks ^= true
        },
        description: 'Bookmarks'
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
        description: 'Game info'
      },
      {
        code: 'KeyF',
        method: () => {
          this.hideAllPanels('fleets')
          this.panelsVisibility.fleets ^= true
        },
        description: 'Fleets in space'
      },
      {
        code: 'KeyA',
        method: () => {
          this.hideAllPanels('autoTasks')
          this.panelsVisibility.autoTasks ^= true
        },
        description: 'Automatic tasks'
      },
      {
        code: 'KeyT',
        method: () => {
          this.hideAllPanels('tasks')
          this.panelsVisibility.tasks ^= true
        },
        description: 'Current tasks'
      },
      {
        code: 'KeyN',
        method: () => {
          this.hideAllPanels('notifications')
          this.panelsVisibility.notifications ^= true
        },
        description: 'Notifications'
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
      quickStartDisabled: this.quickStart,
      winIsFocused: true,
      hotKeys,
      areNotificationsSupported: false,
      forceAutoEndTurn: false,
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
      notifications: 'events/all',
      game: 'game/info',
      quickStart: 'quickStart'
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
      if (this.forceAutoEndTurn) {
        setTimeout(this.endTurn, 300)
      } else if (!this.winIsFocused) {
        if (this._notify) {
          this._notify.close()
        }
        this._notify = new Notification('SpacePal', {
          body: `Turn: ${this.game.turnNumber}`,
          icon: NOTIFICATION_ICON
        })
      }
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
      if (this.forceAutoEndTurn) {
        this.$store.dispatch('game/endTurn')
      } else if (this.$store.getters.isLocked) {
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
  },
  mounted () {
    if (window.Notification && Notification.permission !== 'granted') {
      Notification.requestPermission(permission => {
        this.areNotificationsSupported = permission === 'granted'
      })
    }

    this._blurFunc = () => { this.winIsFocused = false }
    this._focusFunc = () => { this.winIsFocused = true }
    window.addEventListener('focus', this._focusFunc)
    window.addEventListener('blur', this._blurFunc)

    this.quickStartDisabled = !this.quickStart
    if (!this.quickStartDisabled) {
      this.$refs.quickStart.show()
    }
  },
  beforeDestroy () {
    window.removeEventListener('focus', this._focusFunc)
    window.removeEventListener('blur', this._blurFunc)
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

.quick-start-btn, .quick-start-p {
  display: inline-block;
  margin: 8px 0;
}
.quick-start-p {
  text-align: justify;
}
.quick-start-btn {
  display: flex;
  justify-content: center;
}
</style>
