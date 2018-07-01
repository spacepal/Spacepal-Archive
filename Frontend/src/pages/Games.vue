<template>
  <div id="games-page">
    <div class="loop_header"></div>
    <GameTitle></GameTitle>
    <div class="flex-horizontal">
      <div class="space"></div>
      <div id="games-list">
        <STable :fields="fields" :rows="rows" @rowClicked="rowClicked" :loading="isLoading">
          <template slot="notfound">
            There's no games
          </template>
        </STable>
        <Paginator :total="total" :limit="limit" @pageChanged="pageChanged" />
      </div>
      <div class="space"></div>
    </div>
    <Window ref="confirm" type="confirm" title="Confirm action">
      Do you want to join this game?
    </Window>
  </div>
</template>

<script>
import GameTitle from '../components/GameTitle.vue'
import STable from '../components/STable.vue'
import Paginator from '../components/Paginator.vue'
import Window from '../components/Window.vue'
import Service from '../common/Service.js'
export default {
  name: 'Games',
  components: {
    STable,
    Paginator,
    GameTitle,
    Window
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
          'key': 'buffs'
        },
        {
          'name': 'Pirates',
          'key': 'pirates'
        },
        {
          'name': 'Accum',
          'title': 'Accumulative',
          'key': 'accumulative'
        },
        {
          'name': 'PAC',
          'title': 'Production after capture',
          'key': 'production_after_capture'
        }
      ],
      rows: [],
      limit: 18,
      total: 0,
      isLoading: true
    }
  },
  mounted () {
    this.refresh(0)
  },
  methods: {
    refresh (offset) {
      this.isLoading = true
      Service.game.all(0, this.limit).then((resp) => {
        this.isLoading = false
        this.total = resp.data.count
        this.rows = resp.data.games
      }).catch((resp) => {
        this.$toast('Connection error')
        console.error(resp)
      })
    },
    pageChanged (pageInfo) {
      this.refresh(pageInfo.offset)
    },
    rowClicked ({row, i}) {
      if (row.players_count === row.players_limit) {
        this.$toast(`There's no space in the room.`)
      } else {
        this.$refs.confirm.show()
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.flex-horizontal {
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
}
#games-page {
  flex-flow: 1.0;
  min-width: 100%;
}
#games-list {
  display: flex;
  flex-direction: column;
  justify-content: center;
}
.space {
  flex: 1;
}
</style>
