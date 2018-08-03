<template>
  <div>
    <Form>
      <div class="has-spinner" :class="loadingClass">
        <div class="game-info">
          <template v-for="row in all" v-if="!(row.onlyGame && !isGame) && !(row.hideEmpty && row.val === null)">
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
        { field: 'id', adapted: this.$t('ID') },
        { field: 'name', adapted: this.$t('Name') },
        { field: 'turnNumber', adapted: this.$t('Turn'), onlyGame: true },
        { field: 'creator', adapted: this.$t('Creator') },
        { field: 'pinCode', adapted: this.$t('Pin'), hideEmpty: true },
        { field: 'mapWidth', adapted: this.$t('Width') },
        { field: 'mapHeight', adapted: this.$t('Height') },
        { field: 'planets', adapted: this.$t('Planets') },
        { field: 'playersLimit', adapted: this.$t('Players') },
        { field: 'buffs', adapted: this.$t('Buffs') },
        { field: 'pirates', adapted: this.$t('Pirates') },
        { field: 'accumulative', adapted: this.$t('Accum'), title: this.$t('Accumulative') },
        { field: 'productionAfterCapture', adapted: this.$t('PAC'), title: this.$t('Production after capture') }
      ]
    }
  },
  computed: {
    ...mapGetters({
      sync: 'sync',
      isGame: 'game/isGame'
    }),
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
          onlyGame: k.onlyGame,
          hideEmpty: k.hideEmpty,
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
