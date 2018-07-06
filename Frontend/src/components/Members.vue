<template>
  <div>
    <Form class="members-info has-spinner" :class="loadingClass">
      <div class="members">
        <template v-for='i in 4' v-if="Object.keys(members).length === 0">
          <span :key="i + '_ico1'" class="mdi mdi-account-outline mdi-24px"></span>
          <span :key="i + '_name'">Loading...</span>
          <span :key="i + '_ico2'" class="mdi mdi-radiobox-blank mdi-16px"></span>
        </template>
        <template v-for="m in members">
          <span :key="m.username + 'ico1'"
            class="mdi mdi-account-outline mdi-24px"
            :style='memberStyle(m)'>
          </span>
          <span :key="m.username + 'val'" >
            {{m.username}}
          </span>
          <span :key="m.username + 'ico2'" v-if='m.isEndTurn'
            class="mdi mdi-radiobox-marked mdi-16px">
          </span>
          <span :key="m.username + 'ico3'" v-else
            class="mdi mdi-radiobox-blank mdi-16px">
          </span>
        </template>
      </div>
    </Form>
  </div>
</template>

<script>
import Form from './Form'
import Colors from '../common/Colors'
import { mapGetters } from 'vuex'

export default {
  name: 'Members',
  components: { Form },
  data () {
    return {
    }
  },
  computed: {
    ...mapGetters([
      'members',
      'sync'
    ]),
    loadingClass () {
      return this.sync.members ? '' : 'loading'
    }
  },
  methods: {
    memberStyle (member) {
      return {
        color: Colors[member.colorID].bg
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.members {
  display: grid;
  grid-template-columns: auto auto auto;
  span {
    margin: 0 3px;
  }
}
</style>
