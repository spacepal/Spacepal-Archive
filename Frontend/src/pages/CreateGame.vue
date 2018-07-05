<template>
  <div id="create-page" class="flex-vertical">
    <GameTitle></GameTitle>
    <Form ref="form">
      <TextInput v-model="pref.username" label="Username"
        validate='^[0-9A-Za-z_-]*$' :min="1"
        :max="32" @change="checkForm" />
      <TextInput v-model="pref.gamename"
        label="Game name" :max="32" @change="checkForm" />
      <div class="flex-horizontal">
        <TextInput v-model="pref.map.width" label="Map width"
          type="number" :min="2" :max="64" @change="checkForm" />
        <TextInput v-model="pref.map.height" label="Map height"
          type="number" :min="2" :max="64" @change="checkForm" />
      </div>
      <div class="flex-horizontal">
        <TextInput v-model="pref.playersLimit" label="Players limit"
          type="number" :min="2" :max="8" @change="checkForm" />
        <TextInput v-model="pref.planetsCount" label="Planets count"
          type="number" :min="pref.playersLimit"
          @change="checkForm" :max="pref.map.height * pref.map.width"/>
      </div>
      <div class="switches">
        <SwitchBox label="Buffs" v-model="pref.flags.buffs" />
        <SwitchBox label="PAC" v-model="pref.flags.productionAfterCapture"
          title="Production after capture" />
        <SwitchBox label="Pirates" v-model="pref.flags.pirates" />
        <SwitchBox label="Accumulative" v-model="pref.flags.accumulative" />
      </div>
      <div class="flex-horizontal pincode-field">
        <label class="flex-horizontal pincode-switch">
          <span v-if="pref.flags.hasPinCode" class="mdi mdi-lock mdi-24px"></span>
          <span v-else class="mdi mdi-lock-open mdi-24px"></span>
          <SwitchBox title="Has pincode" v-model="pref.flags.hasPinCode" />
        </label>
        <transition name="fade">
          <TextInput v-model="pref.pinCode" label="Pincode"
              type="text" :min="4" :max="4" @change="checkForm"
              :enableValidation="pref.flags.hasPinCode"
              v-show="pref.flags.hasPinCode"
              validate='^[0-9]+$' />
        </transition>
      </div>
      <div class="flex-horizontal">
        <div class="button" @click="goHome">
          <span class="mdi mdi-arrow-left"></span> Back
        </div>
        <div class="button" :class="createButtonClass" @click="createGame">
          <span class="mdi mdi-earth"> </span> Create game
        </div>
        <div class="button" @click="setRandom">
          <span class="mdi mdi-dice-multiple mdi-24px"> </span>
        </div>
      </div>
    </Form>
    <FullPreloader ref="loader"></FullPreloader>
  </div>
</template>

<script>

import GameTitle from '../components/GameTitle.vue'
import TextInput from '../components/TextInput.vue'
import SwitchBox from '../components/SwitchBox.vue'
import FullPreloader from '../components//FullPreloader.vue'
import Form from '../components/Form.vue'
import Faker from 'faker'

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
        { code: 'Enter', method: this.createGame, description: 'Submit' },
        { code: 'Escape', method: this.goHome, description: 'Close' }
      ]
    }
  },
  methods: {
    setRandom () {
      this.pref.username = Faker.name.firstName()
      this.pref.gamename = Faker.company.companyName()
      this.pref.map.width = Faker.random.number({
        min: 5,
        max: 32
      })
      this.pref.map.height = Faker.random.number({
        min: 5,
        max: this.pref.map.width - 1
      })
      this.pref.playersLimit = 8
      this.pref.planetsCount = Faker.random.number({
        min: 8,
        max: this.pref.map.width * this.pref.map.height
      })
      this.pref.pinCode = ''
      this.pref.flags.pirates = Faker.random.boolean()
      this.pref.flags.buffs = Faker.random.boolean()
      this.pref.flags.productionAfterCapture = Faker.random.boolean()
      this.pref.flags.accumulative = Faker.random.boolean()
      this.pref.flags.hasPinCode = false
      this.$nextTick(() => {
        this.$refs.form.forceInput()
      })
    },
    goHome () {
      this.$router.push({name: 'Games'})
    },
    createGame () {
      if (this.$refs.form.isValid()) {
        this.$refs.loader.show()
        this.$store.dispatch('game/create', this.pref).then(gameID => {
          this.$refs.loader.hide()
          this.$toast(`The game #${gameID} is created`)
          console.warn('@todo: CreateGame.vue: createGame() -> redirect on success')
        }).catch(err => {
          this.$refs.loader.hide()
          this.$toast(err.message)
        })
      }
    },
    checkForm () {
      this.createButtonClass = this.$refs.form.isValid() ? '' : 'disabled'
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
