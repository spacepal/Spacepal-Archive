<template>
  <div id="app" :class="theme">
    <div class="bg"></div>
    <router-view/>
    <Window ref="hotKeysWin" type="alert" :title="$t('Hotkeys')">
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
      :title="$t('Settings')" :enabled="settingsAreValid" class="settings">
      <template>
        <Form ref="settingsForm" class="withoutborder">
          <TextInput :label="$t('Host')" v-model="host" :min="1" @change="checkForm" />
          <TextInput type="number" :label="$t('Port')" v-model="port"
            :min="1" :max="65535" @change="checkForm" />
          <p class="flex-horizontal"><SwitchBox :label="$t('Full render')" v-model="slowRender" /></p>
          <p class="flex-horizontal"><SwitchBox :label="$t('Show menu')" v-model="menuIsVisible" /></p>
          <p class="flex-horizontal">
            <a @click="setLocale('en')"
              v-if="$i18n.locale() !== 'en'">English</a>
            <a @click="setLocale('ru')"
              v-if="$i18n.locale() !== 'ru'">Русский</a>
          </p>
        </Form>
      </template>
      <template slot="footer">
        <div class="button" @click="setDefault">
          {{ $t('Default') }}
        </div>
      </template>
    </Window>
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
import Form from './components/Form'
import TextInput from './components/TextInput'
import SwitchBox from './components/SwitchBox'
import Signal from './components/nano/Signal'
import { DEFAULT_BACKEND } from './common/constants.js'
import { mapActions } from 'vuex'
let themes = ['dark', 'light']
let backend = DEFAULT_BACKEND.split(':')

export default {
  name: 'App',
  data () {
    return {
      settingsAreValid: false,
      host: backend[0] || 'localhost',
      port: parseInt(backend[1] || '80'),
      currentTheme: 0,
      hotKeys: [
        {
          code: 'KeyP',
          method: () => {
            this.$refs.settings.show()
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
            this.allHotKeys = this.$allHotKeys()
            this.$refs.hotKeysWin.show()
          },
          description: this.$t('Show hotkeys')
        }
      ],
      allHotKeys: new Map()
    }
  },
  computed: {
    slowRender: {
      get () {
        return this.$store.getters['settings/fullRender']
      },
      set (value) {
        this.setSetting({ key: 'fullRender', value })
      }
    },
    menuIsVisible: {
      get () {
        return this.$store.getters['settings/menuIsVisible']
      },
      set (value) {
        this.setSetting({ key: 'menuIsVisible', value })
      }
    },
    theme () {
      return themes[this.currentTheme]
    }
  },
  components: { Window, Signal, Form, TextInput, SwitchBox },
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
  },
  methods: {
    ...mapActions({
      setSetting: 'settings/set',
      saveLocale: 'saveLocale'
    }),
    checkForm () {
      this.settingsAreValid = this.$refs.settingsForm.isValid()
    },
    setCustom () {
      this.$store.dispatch('setBackendServer', this.host + ':' + this.port)
      location.reload()
    },
    setLocale (locale) {
      this.$i18n.set(locale)
      this.saveLocale(locale)
      location.reload()
    },
    setDefault () {
      this.$store.dispatch('settings/reset')
      this.$store.dispatch('resetBackendServer')
      this.$refs.settings.close()
      location.reload()
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
