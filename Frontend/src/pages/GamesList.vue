<template>
  <div id="games-page">
    <GameTitle></GameTitle>
    <div class="button" id="create-game-button" @click="goToCreate">Create game</div>
    <div class="flex-horizontal">
      <div class="flex-space"></div>
      <div id="games-list">
        <STable :fields="fields" :rows="rows" @rowClicked="rowClicked" :loading="isLoading">
          <template slot="notfound">
            There's no games
          </template>
        </STable>
        <Paginator :total="total" :limit="limit" @pageChanged="pageChanged" />
      </div>
      <div class="flex-space"></div>
    </div>
    <Window ref="confirm" type="confirm" @confirm="joinConfirm"
      title="Confirm action" :enabled="join.isValid">
      <template>
        Do you want to join game #{{ join.gameID }}?
        <Form ref="joinForm" class="withoutborder">
          <TextInput label="Username" v-model="join.username" ref="usernameInput"
            type="text" validate='^[0-9A-Za-z_-]*$' :min="1" :max="32"
            @change="checkJoinForm" :generator="usernameGenerator" />
          <TextInput label="Pincode" v-if="join.hasPinCode" v-model="join.pinCode"
            type="text" :min="4" :max="4" validate='^[0-9]+$'
            :enableValidation="join.hasPinCode" @change="checkJoinForm" />
        </Form>
      </template>
      <template slot="footer">
        <div class="button" @click="setRandom">
          <span class="mdi mdi-dice-multiple mdi-24px"> </span>
        </div>
      </template>
    </Window>
    <FullPreloader ref="loader"></FullPreloader>
  </div>
</template>

<script>
import GameTitle from '../components/nano/GameTitle.vue'
import STable from '../components/STable.vue'
import Paginator from '../components/Paginator.vue'
import Window from '../components/Window.vue'
import TextInput from '../components/TextInput.vue'
import FullPreloader from '../components/FullPreloader.vue'
import Form from '../components/Form.vue'
import Service from '../common/Service.js'
import { UsernameGenerator } from '../common/Generators.js'

const REFRESH_TIMEOUT = 5000

export default {
  name: 'GamesList',
  components: {
    STable,
    Paginator,
    GameTitle,
    Window,
    TextInput,
    FullPreloader,
    Form
  },
  data () {
    return {
      fields: [
        {
          'name': 'ID',
          'key': 'id'
        },
        {
          'name': 'Name',
          'key': 'name'
        },
        {
          'name': 'Creator',
          'key': 'creator'
        },
        {
          'name': 'Planets',
          'key': 'planets_count'
        },
        {
          'name': 'Players',
          'value': (row) => `${row['players_count']}/${row['players_limit']}`
        },
        {
          'name': 'Map',
          'value': (row) => `${row['width']}w*${row['height']}h`
        },
        {
          'name': 'Buffs',
          'key': 'buffs',
          'isBoolean': true
        },
        {
          'name': 'Pirates',
          'key': 'pirates',
          'isBoolean': true
        },
        {
          'name': 'Accum',
          'title': 'Accumulative',
          'key': 'accumulative',
          'isBoolean': true
        },
        {
          'name': 'PAC',
          'title': 'Production after capture',
          'key': 'production_after_capture',
          'isBoolean': true
        },
        {
          'name': '<span class="mdi mdi-lock mdi-24px"></span>',
          'title': 'Is private room',
          'key': 'has_pin_code',
          'isBoolean': true
        }
      ],
      rows: [],
      limit: 9,
      total: 0,
      isLoading: true,
      join: {
        gameID: 0,
        hasPinCode: false,
        pinCode: '',
        username: '',
        isValid: false
      },
      hotKeys: [
        { code: 'KeyN', method: this.goToCreate, description: 'Create game' },
        { code: 'KeyC', method: this.goToCreate, description: 'Create game' }
      ],
      usernameGenerator: () => UsernameGenerator,
      offset: 0
    }
  },
  mounted () {
    let silent = false
    let refreshFunc = () => {
      this.refresh(this.offset, silent)
      silent = true
      this._refreshTimer = setTimeout(refreshFunc, REFRESH_TIMEOUT)
    }
    refreshFunc()
  },
  beforeDestroy () {
    clearTimeout(this._refreshTimer)
  },
  methods: {
    setRandom () {
      this.$refs.usernameInput.regenerate(true)
    },
    joinConfirm () {
      this.$refs.loader.show()
      this.$store.dispatch('game/join', this.join).then(() => {
        this.$refs.loader.hide()
        this.$router.push({ name: 'Game' })
      }).catch(err => {
        this.$refs.loader.hide()
        this.$toast(err.message)
      })
    },
    checkJoinForm () {
      this.join.isValid = this.$refs.joinForm.isValid()
    },
    goToCreate () {
      this.$router.push({
        name: 'CreateGame'
      })
    },
    refresh (offset, silent = false) {
      this.isLoading = !silent
      Service.game.all(offset, this.limit).then((resp) => {
        this.isLoading = false
        this.total = resp.data.count
        this.rows = resp.data.games
      }).catch((resp) => {
        if (!silent) {
          this.$toast('Connection error')
        }
        console.error(resp)
      })
    },
    pageChanged (pageInfo) {
      this.offset = pageInfo.offset
      this.refresh(pageInfo.offset)
    },
    rowClicked ({row, i}) {
      if (row.players_count === row.players_limit) {
        this.$toast(`There's no space in the room.`)
      } else {
        this.join.gameID = row.id
        this.join.pinCode = ''
        this.join.hasPinCode = row.has_pin_code
        this.join.isValid = false
        this.$refs.confirm.show()
      }
    }
  }
}
</script>

<style lang="scss" scoped>
#create-game-button {
  position: absolute;
  right: 10px;
  top: 30px;
}
#games-page {
  min-width: 100%;
}
#games-list {
  display: flex;
  flex-direction: column;
  justify-content: center;
  margin: 10px;
}
</style>
