<template>
  <div id="app" :class="theme">
    <div class="bg"></div>
    <router-view/>
    <HotKeysWin ref="hotKeysWin" />
    <Signal ref="signal" />
    <SettingsWin ref="settingsWin" />
    <Toast ref="toast" glob />
    <Window ref="compitableWindow" :title="$t('Not supported')">
      <p class="text-fail">{{ $t('Sorry. The game is functional only in desktop browsers.') }}</p>
      <p><span class="text-success mdi mdi-google-chrome"></span> {{ $t('supported') }}.</p>
      <p><span class="text-success mdi mdi-firefox"></span> {{ $t('supported') }}.</p>
      <p><span class="text-success mdi mdi-opera"></span> {{ $t('supported') }}?</p>
      <p><span class="text-success mdi mdi-apple-safari"></span> {{ $t('supported') }}?</p>
      <p><span class="text-fail mdi mdi-internet-explorer"></span> {{ $t('not supported') }}.</p>
      <p>
        {{ $t('You can contribute to extend browser support') }}
        <a class="mdi mdi-github-circle"
          href="https://github.com/spacepal/Spacepal">Github</a>
      </p>
    </Window>
  </div>
</template>

<script>
import Window from './components/Window'
import HotKeysWin from './components/win/HotKeysWin'
import SettingsWin from './components/win/SettingsWin'
import Signal from './components/nano/Signal'
let themes = ['dark', 'light']

export default {
  name: 'App',
  data () {
    return {
      settingsAreValid: false,
      currentTheme: 0,
      hotKeys: [
        {
          code: 'KeyP',
          method: () => {
            this.$refs.settingsWin.show()
          },
          description: this.$t('Advanced settings')
        },
        {
          code: 'KeyS',
          method: () => {
            this.$refs.signal.hide()
          },
          methodDown: () => {
            this.$refs.signal.show()
          },
          description: this.$t('Connection status')
        },
        {
          code: 'Space',
          ctrl: true,
          method: () => {
            this.currentTheme = (this.currentTheme + 1) % themes.length
          }
          // description: 'Change theme'
        },
        {
          code: 'KeyK',
          method: () => {
            this.$refs.hotKeysWin.show(this.$allHotKeys())
          }
          // description: this.$t('Show hotkeys')
        }
      ]
    }
  },
  computed: {
    theme () {
      return themes[this.currentTheme]
    }
  },
  components: { Window, HotKeysWin, SettingsWin, Signal },
  mounted () {
    if (this.$store.getters['isPlayer']) {
      this.$store.dispatch('enableCable').catch(() => {
        this.$store.dispatch('logout').catch(err => {
          this.$refs.toast.show(this.$t(err.message))
        })
        this.$router.push({
          name: 'GamesList'
        })
      })
    }
    if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
      this.$refs.compitableWindow.show()
    }
  }
}
</script>

<style lang="scss">
// @import url('https://fonts.googleapis.com/css?family=Share+Tech+Mono');
@import url('https://fonts.googleapis.com/css?family=Audiowide|Oswald&amp;subset=cyrillic');
@import '@mdi/font/css/materialdesignicons.min.css';
@import './css/_ui.scss';
#app {
  position: absolute;
  left: 0;
  top: 0;
  min-width: 100%;
  min-height: 100%;
}

.hotKeysGrid {
  display: grid;
  grid-template-columns: 170px auto auto;
  .splitter {
    margin: 0 10px;
  }
}

.settings * {
  z-index: 10000000000001 !important;
}

</style>
