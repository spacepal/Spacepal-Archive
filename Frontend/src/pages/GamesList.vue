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
    <div class="buttons-right" ref="buttonsCreation">
      <div class="button" @click="createRandom" :title="$t('Create random game')">
        <span class="mdi mdi-dice-multiple mdi-16px"></span>
      </div>
      <div class="button" @click="goToCreate" :title="$t('Create game')">{{ $t('New')}}</div>
    </div>
    <div class="flex-horizontal">
      <div class="flex-space"></div>
      <div id="games-list">
        <STable ref="gamesList" :fields="fields" :rows="rows" @rowClicked="rowClicked"
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
    <JoinWin ref="joinWin" @join="joinConfirm"></JoinWin>
    <FullPreloader ref="loader" />
    <HelpPanel ref="help" name="GamesList" :refs="$refs" />
  </div>
</template>

<script>
import GameTitle from '../components/nano/GameTitle.vue'
import STable from '../components/STable.vue'
import Paginator from '../components/Paginator.vue'
import FullPreloader from '../components/FullPreloader.vue'
import Form from '../components/Form.vue'
import HelpPanel from '../components/HelpPanel.vue'
import JoinWin from '../components/win/JoinWin.vue'
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
    FullPreloader,
    Form,
    HelpPanel,
    JoinWin
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
      hotKeys: [
        { code: 'KeyN', method: this.goToCreate, description: this.$t('Create game') },
        { code: 'KeyC', method: this.goToCreate, description: this.$t('Create game') }
      ],
      offset: 0
    }
  },
  mounted () {
    let silent = false
    let refreshFunc = () => {
      this.refresh(this.offset, silent).then(() => {
        silent = true
        this._refreshTimer = setTimeout(refreshFunc, REFRESH_TIMEOUT)
      })
    }
    refreshFunc()
  },
  beforeDestroy () {
    clearTimeout(this._refreshTimer)
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
        username: UsernameGenerator.next().value
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
    joinByID () {
      this.$refs.joinWin.show({})
    },
    joinConfirm (data) {
      this.$refs.loader.show()
      this.$store.dispatch('game/join', data).then(() => {
        this.$nextTick(() => {
          this.$refs.loader.hide()
          this.$router.push({ name: 'Game' })
        })
      }).catch(err => {
        this.$refs.loader.hide()
        if (data.hasPinCode === false && err.message === INVALID_PIN_MESSAGE) {
          this.$refs.joinWin.show({
            hasPinCode: true,
            gameID: data.gameID,
            username: data.username
          })
        } else {
          this.$toast(this.$t(err.message))
        }
      })
    },
    goToCreate () {
      this.$router.push({
        name: 'CreateGame'
      })
    },
    refresh (offset, silent = false) {
      this.isLoading = !silent
      return new Promise(resolve => {
        Service.game.all(offset, this.limit).then((resp) => {
          this.isLoading = false
          this.total = resp.data.count
          this.rows = resp.data.games
          resolve()
        }).catch((resp) => {
          if (!silent) {
            this.$toast(this.$t('Connection error'))
          }
          resolve()
        })
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
        this.$refs.joinWin.show({
          gameID: row.id,
          hasPinCode: row.has_pin_code
        })
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
