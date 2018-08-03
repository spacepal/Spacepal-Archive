<template>
  <div class="game-page" ref="page">
    <Map ref="map" full @addBookmark="setBookmark" />
    <GamePanel :group="0" panel="main" :empty="true"> <!-- PLAYERS + GAME INFO -->
      <div class="main-panel">
        <Members class="withoutborder" />
        <GameInfo class="withoutborder" />
      </div>
    </GamePanel>
    <GamePanel :group="0" panel="tasks" :title="$t('Tasks')"
      :empty="Object.values(tasks).length == 0"> <!-- TASKS -->
      <Fleets
          :canDelete="true"
          :syncs="['planets', 'profile']"
          :fleets="tasks"
          @goToCell="goToCell"
          @delete="delTask">
        </Fleets>
    </GamePanel>
    <GamePanel :group="0" panel="fleets" :title="$t('Fleets in space')"
      :empty="Object.values(fleets).length == 0"> <!-- FLEETS -->
      <Fleets
        :canDelete="false"
        :syncs="['fleets', 'planets']"
        :fleets="fleets"
        @goToCell="goToCell">
      </Fleets>
    </GamePanel>
    <GamePanel :group="0" panel="autoTasks" :title="$t('Autotasks')"
      :empty="Object.values(autoTasks).length == 0"> <!-- AUTOTASKS -->
      <Fleets
        :canDelete="true"
        :syncs="['planets']"
        :fleets="autoTasks"
        @goToCell="goToCell"
        @delete="delTask"
        :lockAction="false">
      </Fleets>
    </GamePanel>
    <GamePanel :group="0" panel="notifications" :title="$t('Events')"
      :empty="notifications.length == 0"> <!-- NOTIFICATIONS -->
      <Notifications @goToCell="goToCell" />
    </GamePanel>
    <GamePanel :title="$t('Bookmarks')" :group="0" panel="bookmarks" :empty="bookmarksCount === 0"> <!-- BOOKMARKS -->
      <Bookmarks ref="bookmarks" @goToCell="goToCell" />
    </GamePanel>

    <GameMenu @goHome="goHome" @toggleArrows="toggleArrows" />
    <EndTurnMsg @onTurnEnded="onTurnEnded"
      @onTurnAnimationEnded="onTurnAnimationEnded" />
    <Window ref="quickStart" type="alert" :title="$t('Quick start')">
      <template>
        <span class="quick-start-p">At the start of the game you have only one planet — your capital (press <span class="mdi mdi-keyboard mdi-24px splitter"></span>Home for quick goto).</span>
        <span class="quick-start-p">Besides it on the map are located neutral planets (peaceful) and planets of your opponents.</span>
        <span class="quick-start-p">You can attack another planet and captures it. The power of attack per ship depends on kill percentage (kill) of planet-sender.</span>
        <span class="quick-start-p">Every turn, count of ships on the planet is increased by production value (prod).</span>
        <span class="quick-start-p">If you conquer planets of other players — you will win.</span>
        <span class="quick-start-p">Press <span class="mdi mdi-keyboard mdi-24px splitter"></span>K for show all hotkeys</span>
        <span class="quick-start-btn"><SwitchBox v-model="quickStartDisabled" label="Don't show again" :title="$t('You can press KeyL for show quick start again')" /></span>
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
import GamePanel from '../components/GamePanel'

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
    Bookmarks,
    GamePanel
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
        }
        // description: this.$t('Quick start')
      },
      {
        code: 'KeyB',
        method: () => {
          this.togglePanel({ group: 0, panel: 'bookmarks' })
        },
        description: this.$t('Bookmarks')
      },
      {
        code: 'KeyQ',
        method: () => {
          this.hidePanel({ group: 0, panel: 'main' })
        },
        methodDown: () => {
          this.showPanel({ group: 0, panel: 'main' })
        },
        description: this.$t('Game info')
      },
      {
        code: 'KeyF',
        method: () => {
          this.togglePanel({ group: 0, panel: 'fleets' })
        },
        description: this.$t('Fleets in space')
      },
      {
        code: 'KeyA',
        method: () => {
          this.togglePanel({ group: 0, panel: 'autoTasks' })
        },
        description: this.$t('Autotasks')
      },
      {
        code: 'KeyT',
        method: () => {
          this.togglePanel({ group: 0, panel: 'tasks' })
        },
        description: this.$t('Current tasks')
      },
      {
        code: 'KeyN',
        method: () => {
          this.togglePanel({ group: 0, panel: 'notifications' })
        },
        description: this.$t('Notifications')
      },
      {
        code: 'Space',
        method: this.endTurn,
        modalLock: true,
        description: this.$t('End turn')
      },
      {
        code: 'Escape',
        method: () => {
          this.hidePanels(0)
        }
      }
    ]
    return {
      winIsFocused: true,
      hotKeys,
      areNotificationsSupported: false,
      forceAutoEndTurn: false
    }
  },
  computed: {
    ...mapGetters({
      tasks: 'tasks/all',
      fleets: 'fleets/all',
      autoTasks: 'tasks/autoTasks',
      notifications: 'events/all',
      game: 'game/info',
      quickStart: 'quickStart',
      isPlayerlost: 'isPlayerlost',
      bookmarksCount: 'bookmarks/count'
    }),
    quickStartDisabled: {
      get () {
        return !this.quickStart
      },
      set (value) {
        this.setQuickStart(!value)
      }
    }
  },
  methods: {
    ...mapActions({
      delTask: 'tasks/del',
      togglePanel: 'panels/toggle',
      showPanel: 'panels/show',
      hidePanel: 'panels/hide',
      hidePanels: 'panels/hideAll',
      setQuickStart: 'setQuickStart'
    }),
    setBookmark (planetID) {
      this.$refs.bookmarks.setBookmark(planetID)
    },
    onPanelClicked (event, data) {
      if ((data.length !== undefined && data.length === 0) ||
        Object.values(data).length === 0) {

      } else {
        event.preventDefault()
      }
    },
    onTurnEnded () {
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
      this.hidePanel({
        group: 0,
        panel: 'main'
      })
    },
    onTurnAnimationEnded () {
      if (!this.isPlayerlost) {
        this.showPanel({
          group: 0,
          panel: 'notifications'
        })
      }
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
        this.$toast(this.$t('The turn is already ended'))
      } else {
        this.showPanel({ group: 0, panel: 'main' })
        this.$store.dispatch('game/endTurn')
      }
    },
    toggleArrows () {
      this.$refs.map.toggleArrows()
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
    // if (!this.quickStartDisabled) {
    //   this.$refs.quickStart.show()
    // }
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
.main-panel {
  display: flex;
  justify-content: center;
  align-items: center;
  > * {
    margin: 0 10px;
  }
  @media screen and (max-width: 600px) {
    flex-direction: column;
    > * {
      margin: 10px 0;
    }
  }
}
</style>
