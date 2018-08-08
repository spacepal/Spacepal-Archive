<template>
  <div class="menu" v-if="menuIsVisible">
    <span v-if="profile.isEndTurn" class="mdi mdi-progress-check mdi-36px text-success"></span>
    <span v-else class="mdi mdi-menu mdi-36px"></span>
    <div class="items">
      <template v-if="!isLocked">
        <span class="mdi mdi-chess-knight"></span>
        <a @click="endTurn">{{ $t('End turn') }}</a>
        <span>[{{ $t('KeySpace') }}]</span>
      </template>

      <span class="mdi mdi-arrow-decision"></span>
      <a @click="toggleArrows">{{ $t('Directions') }}</a>
      <span>[R]</span>

      <span class="mdi mdi-comment-alert-outline"></span>
      <a @click="showPanel('notifications')">{{ $t('Notifications') }}</a>
      <span>[N]</span>

      <span class="mdi mdi-information-outline"></span>
      <a @click="showPanel('main')">{{ $t('Game info') }}</a>
      <span>[Q]</span>

      <span class="mdi mdi-earth"></span>
      <a @click="goHome">{{ $t('Best planet') }}</a>
      <span>[H]</span>

      <span class="mdi mdi-calendar-check"></span>
      <a @click="showPanel('tasks')">{{ $t('Tasks') }}</a>
      <span>[T]</span>

      <span class="mdi mdi-developer-board"></span>
      <a @click="showPanel('autoTasks')">{{ $t('Auto tasks') }}</a>
      <span>[A]</span>

      <span class="mdi mdi-rocket"></span>
      <a @click="showPanel('fleets')">{{ $t('Fleets') }}</a>
      <span>[F]</span>

      <span class="mdi mdi-bookmark-outline"></span>
      <a @click="showPanel('bookmarks')">{{ $t('Bookmarks') }}</a>
      <span>[B]</span>

      <span class="mdi mdi-comment-multiple-outline"></span>
      <a @click="showPanel('chat')">{{ $t('Chat') }}</a>
      <span>[C]</span>

      <span class="mdi mdi-google-maps"></span>
      <a @click="goToPlanet">{{ $t('Go to planet') }}</a>
      <span>[G]</span>

      <span class="mdi mdi-cancel"></span>
      <a @click="exit">{{ $t('Surrender') }}</a>
      <span>[<span class="mdi mdi-cancel"></span>]</span>

      <span class="mdi mdi-fullscreen"></span>
      <a @click="fullScreen">{{ $t('Fullscreen') }}</a>
      <span>[F11]</span>

      <span class="mdi mdi-eye-off-outline"></span>
      <a @click="toggleVisibility">{{ $t('Hide menu') }}</a>
      <span>[M]</span>
    </div>
    </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'

export default {
  name: 'GameMenu',
  data () {
    return {
      hotKeys: [
        {
          code: 'KeyM',
          method: this.toggleVisibility,
          description: this.$t('Show/hide menu')
        }
      ]
    }
  },
  computed: {
    ...mapGetters({
      menuIsVisible: 'settings/menuIsVisible',
      isLocked: 'isLocked',
      profile: 'profile'
    }),
    isFullScreen: () => document.fullscreen
  },
  mounted () {
    let onFullscreenError = () => {
      this.$toast(this.$t('Press F11 for fullscreen mode'))
    }
    document.addEventListener('fullscreenerror', onFullscreenError)
    document.addEventListener('webkitfullscreenerror', onFullscreenError)
    document.addEventListener('mozfullscreenerror', onFullscreenError)
    document.addEventListener('MSFullscreenError', onFullscreenError)
  },
  methods: {
    ...mapActions({
      endTurn: 'game/endTurn',
      logout: 'logout',
      showGamePanel: 'panels/show',
      toggleVisibility: 'settings/toggleMenuVisibility'
    }),
    exit () {
      this.logout().catch(err => {
        this.$toast(this.$t(err.message))
      })
      this.$router.push({
        name: 'GamesList'
      })
    },
    toggleArrows () {
      this.$emit('toggleArrows')
    },
    showPanel (panelName) {
      this.showGamePanel({
        group: 0,
        panel: panelName
      })
    },
    goHome () {
      this.$emit('goHome')
    },
    goToPlanet () {
      this.$emit('goToPlanet')
    },
    fullScreen () {
      let isFullScreen = document.fullscreen ||
        document.webkitIsFullScreen ||
        document.mozFullScreen
      if (isFullScreen) {
        if (document.exitFullscreen) {
          document.exitFullscreen()
        } else if (document.webkitExitFullscreen) {
          document.webkitExitFullscreen()
        } else if (document.mozCancelFullScreen) {
          document.mozCancelFullScreen()
        } else if (document.msExitFullscreen) {
          document.msExitFullscreen()
        } else {
          this.$toast(this.$t('Press F11'))
        }
      } else {
        let app = document.getElementById('app')
        if (app.requestFullscreen) {
          app.requestFullscreen()
        } else if (app.webkitRequestFullscreen) {
          app.webkitRequestFullscreen()
        } else if (app.mozRequestFullScreen) {
          app.mozRequestFullScreen()
        } else {
          this.$toast(this.$t('Press F11'))
        }
      }
    }
  }
}
</script>

<style lang="scss">
.menu::after {
  content: ''
}

$iconSize: 36px;
$padding: 4px;
$menuBtn: $iconSize + $padding * 2;
.menu a {
  color: white
}
.menu {
  display: flex;
  align-items: center;
  position: fixed;
  top: 0;
  right: 0;
  margin-right: $menuBtn - 3px;
  background: rgba(0, 0, 0, 0.7);
  color: white;
  border-radius: 0 0 0 10px;
  padding: $padding;
  height: 44px;
  transform: translateX(calc(100%));
  transition: transform 0.1s ease-in,
    height 0.1s ease-in;

  .items {
    display: grid;
    grid-template-columns: auto auto auto;
  }

  .items > * {
    margin: 0 3px;
  }
}
.menu:hover {
  transform: translateX($menuBtn);
  height: 340px;
  transition: transform 0.1s ease-out,
    height 0.1s ease-out;
}
</style>
