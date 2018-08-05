<template>
  <div id="create-page" class="flex-vertical">
    <GameTitle></GameTitle>
    <Form ref="form">
      <TextInput v-model="pref.username" :label="$t('Username')" ref="username"
        validate='^[0-9A-Za-z_-]*$' :min="1" :generator="usernameGen"
        :max="32" @change="checkForm" />
      <TextInput v-model="pref.gamename" :generator="gamenameGen" ref="gamename"
        :label="$t('Game name')" :min="1" :max="32" @change="checkForm" />
      <div class="flex-horizontal">
        <TextInput v-model="pref.map.width" :label="$t('Map width')"
          type="number" :min="2" :max="64" @change="checkForm" />
        <TextInput v-model="pref.map.height" :label="$t('Map height')"
          type="number" :min="2" :max="64" @change="checkForm" />
      </div>
      <div class="flex-horizontal">
        <TextInput v-model="pref.playersLimit" :label="$t('Players limit')"
          type="number" :min="2" :max="Math.min(pref.map.width * pref.map.height, 8)" @change="checkForm" />
        <TextInput v-model="pref.planetsCount" :label="$t('Planets count')"
          type="number" :min="pref.playersLimit"
          @change="checkForm" :max="pref.map.height * pref.map.width"/>
      </div>
      <div class="switches">
        <SwitchBox :label="$t('Buffs')" v-model="pref.flags.buffs" />
        <SwitchBox :label="$t('PAC')" v-model="pref.flags.productionAfterCapture"
          :title="$t('Production after capture')" />
        <SwitchBox :label="$t('Pirates')" v-model="pref.flags.pirates" />
        <SwitchBox :label="$t('Accum')"
          :title="$t('Accumulative')" v-model="pref.flags.accumulative" />
      </div>
      <div class="flex-horizontal pincode-field">
        <label class="flex-horizontal pincode-switch">
          <span v-if="pref.flags.hasPinCode" class="mdi mdi-lock mdi-24px"></span>
          <span v-else class="mdi mdi-lock-open mdi-24px"></span>
          <SwitchBox :title="$t('Has pincode')" v-model="pref.flags.hasPinCode" />
        </label>
        <transition name="fade">
          <TextInput v-model="pref.pinCode" :label="$t('Pincode')"
              type="text" :min="4" :max="4" @change="checkForm"
              :enableValidation="pref.flags.hasPinCode"
              v-show="pref.flags.hasPinCode"
              validate='^[0-9]+$' />
        </transition>
      </div>
      <div class="flex-horizontal">
        <div class="button" @click="goHome">
          <span class="mdi mdi-arrow-left"></span> {{ $t('Back') }}
        </div>
        <div class="button" :class="createButtonClass" @click="createGame()">
          <span class="mdi mdi-earth"> </span> {{ $t('Create game') }}
        </div>
        <div class="button" @click="setRandom" :title="$t('Set random parameters')">
          <span class="mdi mdi-dice-multiple mdi-24px"> </span>
        </div>
      </div>
    </Form>
    <FullPreloader ref="loader"></FullPreloader>
  </div>
</template>

<script>

import GameTitle from '../components/nano/GameTitle.vue'
import TextInput from '../components/TextInput.vue'
import SwitchBox from '../components/SwitchBox.vue'
import FullPreloader from '../components//FullPreloader.vue'
import Form from '../components/Form.vue'
import Faker from 'faker'
import { UsernameGenerator, GameNameGenerator } from '../common/Generators.js'

export default {
  name: 'CreateGame',
  components: {
    GameTitle,
    TextInput,
    SwitchBox,
    FullPreloader,
    Form
  },
  data () {
    return {
      usernameGen: () => UsernameGenerator,
      gamenameGen: () => GameNameGenerator,
      createButtonClass: 'disabled',
      pref: {
        username: '',
        gamename: '',
        map: {
          width: 32,
          height: 24
        },
        playersLimit: 8,
        planetsCount: 18,
        pinCode: '',
        flags: {
          buffs: false,
          productionAfterCapture: false,
          pirates: false,
          accumulative: true,
          hasPinCode: false
        }
      },
      hotKeys: [
        { code: 'Enter', method: this.createGame, description: this.$t('Submit'), isKey: true },
        { code: 'Escape', method: this.goHome, description: this.$t('Close'), isKey: true }
      ]
    }
  },
  mounted () {
    this.$disableHotKeys()
    if (this.$route.params['auto']) {
      this.setRandom()
      this.$nextTick(() => {
        this.createGame(true)
      })
    }
  },
  beforeDestroy () {
    this.$enableHotKeys()
  },
  methods: {
    setRandom () {
      this.$refs.username.regenerate()
      this.$refs.gamename.regenerate()
      this.pref.map.width = 5
      this.pref.map.height = 4
      this.pref.planetsCount = 8
      this.pref.playersLimit = 1
      this.pref.pinCode = '1111'
      this.pref.flags.pirates = Faker.random.boolean()
      this.pref.flags.buffs = Faker.random.boolean()
      this.pref.flags.productionAfterCapture = Faker.random.boolean()
      this.pref.flags.accumulative = Faker.random.boolean()
      this.pref.flags.hasPinCode = false
      this.$nextTick(() => {
        this.pref.playersLimit = 8
        this.pref.map.width = Faker.random.number({
          min: 5,
          max: 12
        })
        this.pref.map.height = Faker.random.number({
          min: 5,
          max: this.pref.map.width - 1
        })
        this.pref.planetsCount = Faker.random.number({
          min: 8,
          max: this.pref.map.width * this.pref.map.height
        })
        this.pref.pinCode = ''
        this.$refs.form.forceInput()
      })
    },
    goHome () {
      this.$router.push({ name: 'GamesList' })
    },
    createGame (force = false) {
      if (this.$refs.form.isValid() || force) {
        this.$refs.loader.show()
        this.$store.dispatch('game/create', this.pref).then(gameID => {
          this.$nextTick(() => {
            this.$refs.loader.hide()
            this.$router.push({ name: 'Game' })
          })
        }).catch(err => {
          this.$refs.loader.hide()
          this.$toast(this.$t(err.message))
        })
      }
    },
    checkForm () {
      this.$nextTick(() => {
        this.createButtonClass = this.$refs.form.isValid() ? '' : 'disabled'
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.switches {
  display: grid;
  margin: 0 40px;
  grid-template-columns: auto auto;
  justify-content: space-between;
}
.switches > .switch > * {
  flex: 1;
}
.switches > .switch {
  margin: 8px 0;
  justify-content: space-between;
  text-align: left;
}
.pincode-field {
  align-items: flex-end;
}
.pincode-switch {
  align-items: center;
  flex: 1;
  margin: 9px 20px;
}
</style>
