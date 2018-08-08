<template>
  <div class="game-page" ref="page">
    <Map ref="map" full @addBookmark="setBookmark" />
    <GamePanel ref="gameInfo" :group="0" panel="main" :empty="true"> <!-- PLAYERS + GAME INFO -->
      <div class="main-panel">
        <Members class="withoutborder" />
        <GameInfo class="withoutborder" />
      </div>
    </GamePanel>
    <GamePanel :group="0" panel="tasks" :title="$t('Tasks')"
      :empty="Object.values(tasks).length == 0"> <!-- TASKS -->
      <Fleets ref="tasks"
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

    <GameMenu
      @goHome="goHome"
      @toggleArrows="toggleArrows"
      @goToPlanet="goToCellWindow" /> <!-- MENU -->

    <EndTurnMsg @onTurnEnded="onTurnEnded"
      @onTurnAnimationEnded="onTurnAnimationEnded" /> <!-- END-TURN-MESSAGE -->

    <Window ref="goToCell" type="confirm" :enabled="goToCellInpIsValid"
      :title="$t('Go to planet')" @confirm="goToCell(goToCellInp)"> <!-- GO-TO-PLANET-WINDOW -->
      <Form ref="goToCellForm" class="withoutborder">
        <TextInput type="number" :autoSelect="true"
          :label="$t('Cell ID')" :min="1"
          :max="game['mapWidth'] * game['mapHeight']"
          v-model="goToCellInp"
          @change="checkGoToCellForm"></TextInput>
      </Form>
    </Window>

    <HelpPanel ref="help" name="Game" :data="helpData" :refs="$refs" />
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
import TextInput from '../components/TextInput'
import HelpPanel from '../components/HelpPanel'

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
    GamePanel,
    TextInput,
    HelpPanel
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
        }
      },
      {
        code: 'KeyG',
        method: () => {
          this.goToCellWindow()
        }
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
      goToCellInp: 0,
      goToCellInpIsValid: false,
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
      isPlayerlost: 'isPlayerlost',
      bookmarksCount: 'bookmarks/count',
      autoEvent: 'settings/autoEvent',
      autoGameInfo: 'settings/autoGameInfo'
    }),
    helpData () {
      return {
        accum: this.game.accumulative || false,
        pirates: this.game.pirates || false
      }
    }
  },
  methods: {
    goToCellWindow () {
      this.goToCellInp = 0
      this.goToCellInpIsValid = false
      this.$refs.goToCell.show()
    },
    checkGoToCellForm () {
      this.$nextTick(() => {
        this.goToCellInpIsValid = this.$refs.goToCellForm.isValid()
      })
    },
    ...mapActions({
      delTask: 'tasks/del',
      togglePanel: 'panels/toggle',
      showPanel: 'panels/show',
      hidePanel: 'panels/hide',
      hidePanels: 'panels/hideAll'
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
      if (!this.isPlayerlost && this.autoEvent) {
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
        if (this.autoGameInfo) {
          this.showPanel({ group: 0, panel: 'main' })
        }
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
