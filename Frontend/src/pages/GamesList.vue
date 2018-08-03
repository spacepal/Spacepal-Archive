<template>
  <div id="games-page">
    <div class="loop_header"></div>
    <GameTitle></GameTitle>
    <div class="buttons-left">
      <template v-if="total != 0">
        <div class="button" @click="joinByID" :title="$t('Join game by ID')">
          <span>{{ $t('Join')}}</span>
        </div>
        <div class="button" @click="joinRandom" :title="$t('Join random game')">
          <span class="mdi mdi-auto-fix mdi-16px"></span>
        </div>
      </template>
      <div class="button" @click="goToGithub" :title="$t('Star on github')">
        <span class="mdi mdi-github-circle mdi-16px"></span>
      </div>
    </div>
    <div class="buttons-right">
      <div class="button" @click="createRandom" :title="$t('Create random game')">
        <span class="mdi mdi-dice-multiple mdi-16px"></span>
      </div>
      <div class="button" @click="goToCreate" :title="$t('Create game')">{{ $t('New')}}</div>
    </div>
    <div class="flex-horizontal">
      <div class="flex-space"></div>
      <div id="games-list">
        <STable :fields="fields" :rows="rows" @rowClicked="rowClicked"
          @notFoundCliked="createRandom" :loading="isLoading">
          <template slot="notfound">
            <p>
              {{ $t('Click for create first random game') }}
            </p>
          </template>
        </STable>
        <Paginator :total="total" :limit="limit" @pageChanged="pageChanged" />
      </div>
      <div class="flex-space"></div>
    </div>
    <Window ref="confirm" type="confirm" @confirm="joinConfirm"
      :title="$t('Confirm action')" :enabled="join.isValid">
      <template>
        {{ $t('Do you want to join game') }}<span v-if="!join.unknowGameID"> #{{ join.gameID }}</span>?
        <Form ref="joinForm" class="withoutborder">
          <TextInput :label="$t('Game ID')" v-model="join.gameID" ref="usernameInput"
            type="number" v-if="join.unknowGameID" :min="1" force
            @change="checkJoinForm" />
          <TextInput :label="$t('Username')" v-model="join.username" ref="usernameInput"
            type="text" validate='^[0-9A-Za-z_-]*$' :min="1" :max="32" force
            @change="checkJoinForm" :generator="usernameGenerator" />
          <TextInput ref="pin" :label="$t('Pincode')" v-if="join.hasPinCode" v-model="join.pinCode"
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
const INVALID_PIN_MESSAGE = 'the pin code is wrong'

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
          'name': this.$t('ID'),
          'key': 'id'
        },
        {
          'name': this.$t('Name'),
          'key': 'name'
        },
        {
          'name': this.$t('Creator'),
          'key': 'creator'
        },
        {
          'name': this.$t('Planets'),
          'key': 'planets_count'
        },
        {
          'name': this.$t('Players'),
          'value': (row) => `${row['players_count']}/${row['players_limit']}`
        },
        {
          'name': this.$t('Map'),
          'value': (row) => `${row['width']}w*${row['height']}h`
        },
        {
          'name': this.$t('Buffs'),
          'key': 'buffs',
          'isBoolean': true
        },
        {
          'name': this.$t('Pirates'),
          'key': 'pirates',
          'isBoolean': true
        },
        {
          'name': this.$t('Accum'),
          'title': this.$t('Accumulative'),
          'key': 'accumulative',
          'isBoolean': true
        },
        {
          'name': this.$t('PAC'),
          'title': this.$t('Production after capture'),
          'key': 'production_after_capture',
          'isBoolean': true
        },
        {
          'name': '<span class="mdi mdi-lock mdi-24px"></span>',
          'title': this.$t('Is private room'),
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
        pinCode: undefined,
        username: '',
        isValid: false
      },
      hotKeys: [
        { code: 'KeyN', method: this.goToCreate, description: this.$t('Create game') },
        { code: 'KeyC', method: this.goToCreate, description: this.$t('Create game') }
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
  watch: {
    'join.gameID': function () {
      if (this.join.unknowGameID) {
        this.join.hasPinCode = false
      }
    }
  },
  methods: {
    goToGithub () {
      window.open('https://github.com/spacepal/Spacepal', '_blank').focus()
    },
    createRandom () {
      this.$router.push({
        name: 'CreateGame',
        params: {
          auto: true
        }
      })
    },
    joinRandom () {
      this.$refs.loader.show()
      this.$store.dispatch('game/joinRandom', {
        username: this.usernameGenerator().next().value
      }).then(() => {
        this.$nextTick(() => {
          this.$refs.loader.hide()
          this.$router.push({ name: 'Game' })
        })
      }).catch(err => {
        this.$refs.loader.hide()
        this.$toast(this.$t(err.message))
      })
    },
    setRandom () {
      this.$refs.usernameInput.regenerate(true)
    },
    joinByID () {
      this.join.gameID = undefined
      this.join.pinCode = undefined
      this.join.hasPinCode = false
      this.join.isValid = false
      this.join.unknowGameID = true
      this.join.username = ''
      this.$refs.confirm.show()
    },
    joinConfirm () {
      this.$refs.loader.show()
      this.$store.dispatch('game/join', this.join).then(() => {
        this.$nextTick(() => {
          this.$refs.loader.hide()
          this.$router.push({ name: 'Game' })
        })
      }).catch(err => {
        this.$refs.loader.hide()
        if (this.join.hasPinCode === false && err.message === INVALID_PIN_MESSAGE) {
          this.join.hasPinCode = true
          this.$refs.confirm.show()
          this.$nextTick(() => {
            setTimeout(() => {
              this.$refs.pin.focus()
            }, 100)
          })
        } else {
          this.$toast(this.$t(err.message))
        }
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
          this.$toast(this.$t('Connection error'))
        }
      })
    },
    pageChanged (pageInfo) {
      this.offset = pageInfo.offset
      this.refresh(pageInfo.offset)
    },
    rowClicked ({row, i}) {
      if (row.players_count === row.players_limit) {
        this.$toast(this.$t('There\'s no space in the room.'))
      } else {
        this.join.gameID = row.id
        this.join.pinCode = undefined
        this.join.username = ''
        this.join.hasPinCode = row.has_pin_code
        this.join.isValid = false
        this.join.unknowGameID = false
        this.$refs.confirm.show()
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.buttons-left, .buttons-right {
  position: absolute;
  top: 30px;
  display: flex;
}
.buttons-left {
  left: 10px;
}
.buttons-right {
  right: 10px;
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
