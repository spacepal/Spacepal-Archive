<template>
  <div class="menu" v-if="menuIsVisible">
    <span v-if="profile.isEndTurn" class="mdi mdi-progress-check mdi-36px text-success"></span>
    <span v-else class="mdi mdi-menu mdi-36px"></span>
    <div class="items">
      <template v-if="!isLocked">
        <span class="mdi mdi-chess-knight"></span>
        <a @click="endTurn">End turn</a>
        <span>[Space]</span>
      </template>

      <span class="mdi mdi-arrow-decision"></span>
      <a @click="toggleArrows">Directions</a>
      <span>[R]</span>

      <span class="mdi mdi-comment-alert-outline"></span>
      <a @click="showPanel('notifications')">Notifications</a>
      <span>[N]</span>

      <span class="mdi mdi-information-outline"></span>
      <a @click="showPanel('main')">Game info</a>
      <span>[Q]</span>

      <span class="mdi mdi-earth"></span>
      <a @click="goHome">Best planet</a>
      <span>[H]</span>

      <span class="mdi mdi-calendar-check"></span>
      <a @click="showPanel('tasks')">Tasks</a>
      <span>[T]</span>

      <span class="mdi mdi-developer-board"></span>
      <a @click="showPanel('autoTasks')">Auto tasks</a>
      <span>[A]</span>

      <span class="mdi mdi-rocket"></span>
      <a @click="showPanel('fleets')">Fleets</a>
      <span>[F]</span>

      <span class="mdi mdi-bookmark-outline"></span>
      <a @click="showPanel('bookmarks')">Bookmarks</a>
      <span>[B]</span>

      <span class="mdi mdi-cancel"></span>
      <a @click="exit">Surrender</a>
      <span>[<span class="mdi mdi-cancel"></span>]</span>

      <span class="mdi mdi-fullscreen"></span>
      <a @click="fullScreen">Fullscreen</a>
      <span>[F11]</span>

      <span class="mdi mdi-eye-off-outline"></span>
      <a @click="toggleVisibility">Hide menu</a>
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
          description: 'Show/hide menu'
        }
      ]
    }
  },
  computed: {
    ...mapGetters(['menuIsVisible', 'isLocked', 'profile']),
    isFullScreen: () => document.fullscreen
  },
  mounted () {
    let onFullscreenError = () => {
      this.$toast('Press F11 for fullscreen mode')
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
      showGamePanel: 'panels/show'
    }),
    exit () {
      this.logout().catch(err => {
        this.$toast(err.message)
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
    toggleVisibility () {
      this.$store.dispatch('toggleMenuVisibility')
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
          this.$toast('Press F11')
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
          this.$toast('Press F11')
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
  height: 280px;
  transition: transform 0.1s ease-out,
    height 0.1s ease-out;
}
</style>
