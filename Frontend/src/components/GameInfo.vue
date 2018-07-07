<template>
  <div>
    <Form>
      <div class="has-spinner" :class="loadingClass">
        <div class="game-info">
          <template v-for="row in all">
            <span :key="row.key + '_key'" :title="row.title">{{row.key}}:</span>
            <span :key="row.key + '_val'" :title="row.title">
              <span v-if="typeof row.val !== 'boolean'"
                class="value" :title="row.val">
                {{row.val}}
              </span>
              <span v-else>
                <span v-if="row.val"
                  class="mdi mdi-check mdi-24px"></span>
                <span v-else
                  class="mdi mdi-cancel mdi-24px"></span>
              </span>
            </span>
          </template>
        </div>
      </div>
    </Form>
  </div>
</template>

<script>
import Form from './Form'
import { mapGetters } from 'vuex'

export default {
  name: 'GameInfo',
  components: { Form },
  data () {
    return {
      keys: [
        { field: 'id', adapted: 'ID' },
        { field: 'name', adapted: 'Name' },
        { field: 'creator', adapted: 'Creator' },
        { field: 'pinCode', adapted: 'Pin' },
        { field: 'mapWidth', adapted: 'Width' },
        { field: 'mapHeight', adapted: 'Height' },
        { field: 'planets', adapted: 'Planets' },
        { field: 'playersLimit', adapted: 'Players' },
        { field: 'buffs', adapted: 'Buffs' },
        { field: 'pirates', adapted: 'Pirates' },
        { field: 'accumulative', adapted: 'Accum', title: 'Accumulative' },
        { field: 'productionAfterCapture', adapted: 'PAC', title: 'Production after capture' }
      ]
    }
  },
  computed: {
    ...mapGetters([
      'sync'
    ]),
    loadingClass () {
      return this.sync.game ? '' : 'loading'
    },
    all () {
      let info = this.$store.getters['game/info']
      return this.keys.map(k => {
        let val = info[k.field]
        if (val === undefined) {
          val = 'loading...'
        }
        return {
          title: k.title || '',
          key: k.adapted,
          val
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.game-info {
  display: grid;
  grid-template-columns: 80px auto;
  justify-content: center;

  span {
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
}
</style>
