<template>
  <div class="has-spinner" :class="loadingClass">
    <div v-if="this.adoptedFleets.length > 0" class="tasks">
      <template>
        <a @click="changeSort('fromCell')">{{ $t('From') }}
          <span class="mdi mdi-sort-ascending"
            v-if="sortKey === 'fromCell' && sortType === +1"></span>
          <span class="mdi mdi-sort-descending"
            v-if="sortKey === 'fromCell' && sortType === -1"></span>
        </a>
        <a @click="changeSort('toCell')">{{ $t('To') }}
          <span class="mdi mdi-sort-ascending"
            v-if="sortKey === 'toCell' && sortType === +1"></span>
          <span class="mdi mdi-sort-descending"
            v-if="sortKey === 'toCell' && sortType === -1"></span>
        </a>
        <a @click="changeSort('player')">{{ $t('Player') }}
          <span class="mdi mdi-sort-ascending"
            v-if="sortKey === 'player' && sortType === +1"></span>
          <span class="mdi mdi-sort-descending"
            v-if="sortKey === 'player' && sortType === -1"></span>
        </a>
        <a @click="changeSort('count')">{{ $t('Count') }}
          <span class="mdi mdi-sort-ascending"
            v-if="sortKey === 'count' && sortType === +1"></span>
          <span class="mdi mdi-sort-descending"
            v-if="sortKey === 'count' && sortType === -1"></span>
        </a>
        <a @click="changeSort('kill')">{{ $t('Kill') }}
          <span class="mdi mdi-sort-ascending"
            v-if="sortKey === 'kill' && sortType === +1"></span>
          <span class="mdi mdi-sort-descending"
            v-if="sortKey === 'kill' && sortType === -1"></span>
        </a>
        <a @click="changeSort('stepsLeft')">{{ $t('Steps') }}
          <span class="mdi mdi-sort-ascending"
            v-if="sortKey === 'stepsLeft' && sortType === +1"></span>
          <span class="mdi mdi-sort-descending"
            v-if="sortKey === 'stepsLeft' && sortType === -1"></span>
        </a>
        <span>
          <template v-if="canDelete">
            {{ $t('Action') }}
          </template>
        </span>
      </template>
      <template v-for="fleet in adoptedFleets">
        <Planet :id="fleet.from" :key="fleet.id + '_1'" @goToCell="goToCell"></Planet>
        <Planet :id="fleet.to" :key="fleet.id + '_2'" @goToCell="goToCell"></Planet>
        <Member :key="fleet.id + '_3'" :planetID="fleet.to"></Member>
        <span :key="fleet.id + '_4'">
          {{ fleet.count }}
          <span class="mdi mdi-earth" v-if="fleet.hold"></span>
          <span class="mdi mdi-arrow-up" v-if="fleet.dispatch"></span>
        </span>
        <span :key="fleet.id + '_5'">
          {{ fleet.kill }}
        </span>
        <span :key="fleet.id + '_6'">
          {{ fleet.stepsLeft }}
        </span>
        <span :key="fleet.id + '_7'">
          <template v-if="canDelete">
            <a v-if="actionEnabled" @click="del(fleet.id)">{{ $t('delete') }}</a>
            <span v-else>{{ $t('no') }}</span>
          </template>
        </span>
      </template>
    </div>
    <p v-else>
      <slot name="noFleets"><span class="text-additional">{{ $t('Empty') }}</span></slot>
    </p>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import Member from './nano/Member'
import Planet from './nano/Planet'

export default {
  name: 'Fleets',
  props: {
    fleets: Object,
    syncs: Array,
    canDelete: Boolean,
    lockAction: {
      type: Boolean,
      default: true
    }
  },
  data () {
    return {
      sortKey: 'from',
      sortType: +1 // +1 (asc)/-1 (desc)
    }
  },
  components: { Member, Planet },
  methods: {
    goToCell (cellID) {
      this.$emit('goToCell', cellID)
    },
    del (id) {
      this.$emit('delete', id)
    },
    changeSort (key) {
      if (this.sortKey === key) {
        this.sortType *= -1
      } else {
        this.sortType = +1
        this.sortKey = key
      }
    }
  },
  computed: {
    ...mapGetters(['sync', 'isLocked', 'planetByID']),
    actionEnabled () {
      return !this.isLocked || this.lockAction === false
    },
    adoptedFleets () {
      let t = []
      for (let id in this.fleets) {
        let f = Object.assign({}, this.fleets[id])
        f.id = id
        let from = this.planetByID(f.from)
        if (from !== undefined) {
          f.kill = from.killPerc
          f.fromCell = from.cellID
        } else {
          f.kill = 0
          f.fromCell = 0
        }
        let to = this.planetByID(f.to)
        if (to !== undefined) {
          f.player = to.ownerID
          f.toCell = to.cellID
        } else {
          f.player = 0
          f.toCell = 0
        }
        t.push(f)
      }
      t.sort((a, b) => (a[this.sortKey] - b[this.sortKey]) * this.sortType)
      return t
    },
    loadingClass () {
      let isSynced = true
      this.syncs.forEach((sync) => {
        isSynced &= this.sync[sync]
      })
      return isSynced ? '' : 'loading'
    }
  }
}
</script>

<style lang="scss" scoped>
.tasks {
  display: grid;
  justify-content: space-around;
  grid-template-columns: auto auto auto auto auto auto auto;
  user-select: none;
}
.tasks > * {
  margin: 5px 20px;
  text-align: center
}
</style>
