<template>
  <div class="bookmarkInfo">
    <!-- NODATA -->
    <span v-if="count === 0 && isSelectMode == false" class="text-additional emptySlot">
      You don't have bookmarks.<br>
      Hold KeyB and select planet for create ones.
    </span>
    <!-- HEADER -->
    <template v-else>
      <span>slot</span>
      <span>planet</span>
      <span>owner</span>
      <span>prod</span>
      <span>kill</span>
      <span>ships</span>
      <span class="action">action</span>
    </template>
    <!-- BODY -->
    <template v-for="(planet, slot) in slots">
      <template v-if="(!planet && isSelectMode)">
        <span :key="slot + '1'">{{ slot }}</span>
        <span :key="slot + '2'" class="emptySlot text-additional">Empty slot</span>
      </template>
      <template v-if="planet">
        <span :key="slot + '1'">{{ slot }}</span>
        <Planet :key="slot + '2'" @goToCell="goToCell" :id="planet.id" />
        <Member :key="slot + '3'" :id="planet.ownerID" />
        <span :key="slot + '4'">{{ planet.production }}</span>
        <span :key="slot + '5'">{{ planet.killPerc }}</span>
        <span :key="slot + '6'">{{ planet.ships }}</span>
        <a :key="slot + '7'" v-if="!isSelectMode" class="mdi mdi-delete-forever"
          @click="resetSlot(slot)"></a>
      </template>
      <a :key="slot + '7'" v-if="isSelectMode" @click="select(slot)">[select]</a>
    </template>
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex'
import Planet from './nano/Planet'
import Member from './nano/Member'
import { MIN_BOOKMARK_SLOT, MAX_BOOKMARK_SLOT } from '../common/constants'

export default {
  name: 'Bookmarks',
  data () {
    let hotKeys = []
    for (let i = MIN_BOOKMARK_SLOT; i <= MAX_BOOKMARK_SLOT; ++i) {
      hotKeys.push({
        code: i + '',
        methodDown: () => {
          if (this.isSelectMode) {
            this.select(i)
          } else {
            let slot = this.slots[i]
            if (slot) {
              this.goToCell(this.slots[i].cellID)
            }
          }
        },
        description: 'Goto bookmark',
        isKey: true,
        modalLock: true
      })
    }
    return {
      isSelectMode: false,
      pendingPlanetID: undefined,
      hotKeys
    }
  },
  components: {
    Planet,
    Member
  },
  methods: {
    ...mapActions({
      setSlot: 'bookmarks/setSlot',
      resetSlot: 'bookmarks/resetSlot'
    }),
    setBookmark (planetID) {
      this.pendingPlanetID = planetID
      this.isSelectMode = true
    },
    goToCell (cellID) {
      this.$emit('goToCell', cellID)
    },
    resetSelection () {
      this.isSelectMode = false
    },
    select (slot) {
      if (this.pendingPlanetID) {
        this.setSlot({
          planetID: this.pendingPlanetID,
          slot
        })
      }
      this.isSelectMode = false
    }
  },
  computed: {
    ...mapGetters({
      slots: 'bookmarks/all',
      count: 'bookmarks/count'
    })
  }
}
</script>

<style lang="scss" scoped>
.bookmarkInfo {
  display: grid;
  grid-template-columns: auto auto auto auto auto auto auto;
  text-align: center;
}
.bookmarkInfo * {
  padding: 2px 4px
}
.emptySlot {
  text-align: left !important;
  grid-column-start: 2;
  grid-column-end: 7;
}
.action {
  grid-column-start: 7;
  grid-column-end: 8;
}
</style>
