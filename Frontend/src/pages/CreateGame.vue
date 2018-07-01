<template>
  <div id="create-page" class="flex-vertical">
    <GameTitle></GameTitle>
    <div class="form">
      <TextInput ref="unInp" v-model="pref.username" label="Username"
        validate='^[0-9A-Za-z_-]*$' :min="4" :max="32" @change="checkForm" />
      <TextInput ref="gnInp" v-model="pref.gamename"
        label="Game name" :max="48" @change="checkForm" />
      <div class="flex-horizontal">
        <TextInput ref="mwInp" v-model="pref.map.width" label="Map width"
          type="number" :min="8" :max="1024" @change="checkForm" />
        <TextInput ref="mhInp" v-model="pref.map.height" label="Map height"
          type="number" :min="8" :max="1024" @change="checkForm" />
      </div>
      <div class="flex-horizontal">
        <TextInput ref="plInp" v-model="pref.playersLimit" label="Players limit"
          type="number" :min="2" :max="8" @change="checkForm" />
        <TextInput ref="pcInp" v-model="pref.planetsCount" label="Planets count"
          type="number" :min="pref.playersLimit" @change="checkForm"
          :max="pref.map.height*pref.map.width"/>
      </div>
      <div class="switches">
        <SwitchBox label="Buffs" v-model="pref.flags.buffs" />
        <SwitchBox label="PAC" v-model="pref.flags.productionAfterCapture"
          title="Production after capture" />
        <SwitchBox label="Pirates" v-model="pref.flags.pirates" />
        <SwitchBox label="Accumulative" v-model="pref.flags.accumulative" />
      </div>
      <div class="flex-horizontal">
        <div class="button" @click="goHome">
          <span class="mdi mdi-arrow-left"></span> Back
        </div>
        <div class="button" :class="createButtonClass" @click="createGame">
          <span class="mdi mdi-earth"> </span> Create game
        </div>
      </div>
    </div>
    <FullPreloader ref="loader"></FullPreloader>
  </div>
</template>

<script>
import GameTitle from '../components/GameTitle.vue'
import TextInput from '../components/TextInput.vue'
import SwitchBox from '../components/SwitchBox.vue'
import FullPreloader from '../components//FullPreloader.vue'

export default {
  name: 'CreateGame',
  components: {
    GameTitle,
    TextInput,
    SwitchBox,
    FullPreloader
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
        flags: {
          buffs: false,
          productionAfterCapture: false,
          pirates: false,
          accumulative: true
        }
      }
    }
  },
  methods: {
    goHome () {
      this.$router.push({name: 'Games'})
    },
    createGame () {
      if (this.isFormValid()) {
        this.$refs.loader.show()
      }
    },
    isFormValid () {
      let validadeInp = [this.$refs.unInp, this.$refs.gnInp, this.$refs.mwInp,
        this.$refs.mhInp, this.$refs.plInp, this.$refs.pcInp]
      return !validadeInp.some((el) => {
        return !el.isValid()
      })
    },
    checkForm () {
      this.createButtonClass = this.isFormValid() ? '' : 'disabled'
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
</style>
