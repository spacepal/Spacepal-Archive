<template>
  <div>
    <Window ref="settings" @confirm="setCustom" type="custom"
      :title="$t('Settings')" class="settings">
      <template>
        <Form ref="settingsForm" class="withoutborder">
          <TextInput :label="$t('Host')" v-model="host" :min="1" @change="checkForm" />
          <TextInput type="number" :label="$t('Port')" v-model="port"
            :min="1" :max="65535" @change="checkForm" class="port-inp" />
          <div class="flex-horizontal">
            <div class="button" @click="setCustom" :class="saveBtnClass">
              {{ $t('Save settings') }}
            </div>
            <div class="button" @click="setDefault">
              {{ $t('Default') }}
            </div>
          </div>
        </Form>
        <p class="flex-horizontal">
          <SwitchBox :label="$t('Full render')" v-model="slowRender" />
        </p>
        <p class="flex-horizontal">
          <SwitchBox :label="$t('Show menu')" v-model="menuIsVisible" />
        </p>
        <p class="flex-horizontal">
          <a @click="setLocale('en')"
            v-if="$i18n.locale() !== 'en'">English</a>
          <a @click="setLocale('ru')"
            v-if="$i18n.locale() !== 'ru'">Русский</a>
        </p>
      </template>
      <template slot="footer">
        <div class="button" @click="hideSettings">
          {{ $t('Close') }}
        </div>
      </template>
    </Window>
  </div>
</template>

<script>
import Window from '../Window'
import Form from '../Form'
import TextInput from '../TextInput'
import SwitchBox from '../SwitchBox'
import { DEFAULT_BACKEND } from '../../common/constants.js'
import { mapActions } from 'vuex'
let backend = DEFAULT_BACKEND.split(':')

export default {
  name: 'SettingsWin',
  components: { Window, Form, TextInput, SwitchBox },
  data () {
    return {
      host: backend[0] || 'localhost',
      port: parseInt(backend[1] || '80'),
      settingsAreValid: false
    }
  },
  computed: {
    saveBtnClass () {
      return this.settingsAreValid ? '' : 'disabled'
    },
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
    }
  },
  methods: {
    ...mapActions({
      setSetting: 'settings/set',
      saveLocale: 'saveLocale'
    }),
    hideSettings () {
      this.$refs.settings.close()
    },
    checkForm () {
      this.settingsAreValid = this.$refs.settingsForm.isValid()
    },
    setCustom () {
      if (this.settingsAreValid) {
        this.$store.dispatch('setBackendServer', this.host + ':' + this.port)
        location.reload()
      }
    },
    setDefault () {
      this.$store.dispatch('settings/reset')
      this.$store.dispatch('resetBackendServer')
      this.$refs.settings.close()
      location.reload()
    },
    setLocale (locale) {
      this.$i18n.set(locale)
      this.saveLocale(locale)
      location.reload()
    },
    show () {
      this.$refs.settings.show()
    }
  }
}
</script>
