<template>
  <div id="games-page">
    <div class="loop_header"></div>
    <div id="games-list">
      <STable :fields="fields" :rows="rows" @rowClicked="rowClicked" />
      <Paginator :total="total" :limit="limit" @pageChanged="pageChanged" />
    </div>
  </div>
</template>

<script>
import STable from '../components/STable.vue'
import Paginator from '../components/Paginator.vue'
import Service from '../common/Service.js'
export default {
  name: 'Games',
  components: {
    STable,
    Paginator
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
      total: 0
    }
  },
  mounted () {
    this.refresh(0)
  },
  methods: {
    refresh (offset) {
      Service.game.all(0, this.limit).then((resp) => {
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
      this.$toast(`${row.name}#${i + 1} is clicked`)
    }
  }
}
</script>

<style lang="scss" scoped>
#games-page {
  display: flex;
  flex-direction: column;
  width: 100%;
  align-items: center;
  height: 100%;
}
#games-list {
  display: flex;
  flex-direction: column;
  justify-content: center;
}
</style>
