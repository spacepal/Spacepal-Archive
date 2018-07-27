<template>
  <div id="app" :class="theme">
    <div class="bg"></div>
    <router-view/>
    <Window ref="hotKeysWin" type="alert" title="Hotkeys">
      <div class="hotKeysGrid">
        <template v-for="list in Array.from(allHotKeys)">
          <span :key="list[0] + '-description'">{{list[0]}}</span>
          <span :key="list[0] + '-icon'" class="mdi mdi-keyboard mdi-24px splitter"></span>
          <span :key="list[0] + '-hotkeys'">{{Array.from(list[1]).join(', ')}}</span>
        </template>
      </div>
    </Window>
    <Signal ref="signal" />
    <Window ref="settings" type="confirm" @confirm="setCustom"
      title="Backend settings" :enabled="settingsAreValid" class="settings">
      <template>
        <Form ref="settingsForm" class="withoutborder">
          <TextInput label="Host" v-model="host" :min="1" @change="checkForm" />
          <TextInput type="number" label="Port" v-model="port"
            :min="1" :max="65535" @change="checkForm" />
        </Form>
      </template>
      <template slot="footer">
        <div class="button" @click="setDefault">
          Default
        </div>
      </template>
    </Window>
    <Toast ref="toast" glob />
    <Window ref="compitableWindow" title="Not supported">
      <p class="text-fail">Sorry. The game is functional only in desktop browsers.</p>
      <p><span class="text-success mdi mdi-google-chrome"></span> supported.</p>
      <p><span class="text-success mdi mdi-firefox"></span> supported.</p>
      <p><span class="text-success mdi mdi-opera"></span> supported?</p>
      <p><span class="text-success mdi mdi-apple-safari"></span> supported?</p>
      <p><span class="text-fail mdi mdi-internet-explorer"></span> not supported.</p>
      <p>
        You can contribute to extend browser support
        <a class="mdi mdi-github-circle"
          href="https://github.com/spacepal/Spacepal">Github</a>
      </p>
    </Window>
  </div>
</template>

<script>
import Window from './components/Window'
import Form from './components/Form'
import TextInput from './components/TextInput'
import Signal from './components/nano/Signal'
import { DEFAULT_HOST } from './common/constants.js'
let themes = ['dark', 'light']
let backend = DEFAULT_HOST.split(':')

export default {
  name: 'App',
  data () {
    return {
      settingsAreValid: false,
      host: backend[0] || 'localhost',
      port: parseInt(backend[1] || '3000'),
      currentTheme: 0,
      hotKeys: [
        {
          code: 'KeyP',
          method: () => {
            this.$refs.settings.show()
          },
          description: 'Advanced settings'
        },
        {
          code: 'KeyS',
          method: () => {
            this.$refs.signal.hide()
          },
          methodDown: () => {
            this.$refs.signal.show()
          },
          description: 'Connection status'
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
            this.allHotKeys = this.$allHotKeys()
            this.$refs.hotKeysWin.show()
          },
          description: 'Show hotkeys'
        }
      ],
      allHotKeys: new Map()
    }
  },
  computed: {
    theme () {
      return themes[this.currentTheme]
    }
  },
  components: { Window, Signal, Form, TextInput },
  mounted () {
    if (this.$store.getters['isPlayer']) {
      this.$store.dispatch('enableCable').catch(() => {
        this.$store.dispatch('logout').catch(err => {
          this.$refs.toast.show(err.message)
        })
        this.$router.push({
          name: 'GamesList'
        })
      })
    }
    if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
      this.$refs.compitableWindow.show()
    }
  },
  methods: {
    checkForm () {
      this.settingsAreValid = this.$refs.settingsForm.isValid()
    },
    setCustom () {
      this.$store.dispatch('setBackendServer', this.host + ':' + this.port)
      location.reload()
    },
    setDefault () {
      this.$store.dispatch('resetBackendServer')
      this.$refs.settings.close()
      location.reload()
    }
  }
}
</script>

<style lang="scss">
// @import url('https://fonts.googleapis.com/css?family=Share+Tech+Mono');
@import url('https://fonts.googleapis.com/css?family=Audiowide');
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
