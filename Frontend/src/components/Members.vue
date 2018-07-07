<template>
  <div>
    <Form class="members-info has-spinner" :class="loadingClass">
      <div class="members">
        <template v-for='i in 4' v-if="Object.keys(members).length === 0">
          <span :key="i + '_1'" class="mdi mdi-account-outline mdi-24px"></span>
          <span :key="i + '_2'">Loading...</span>
          <span :key="i + '_3'" class="mdi mdi-radiobox-blank mdi-16px"></span>
        </template>
        <template v-for="m in members">
          <Member :key="m.username + '_1'" :id="m.id"></Member>
          <span v-if="m.isGameOver" :key="m.username + '_2'"></span>
          <template v-else>
            <span :key="m.username + '_3'" v-if='m.isEndTurn'
              class="mdi mdi-radiobox-marked mdi-16px">
            </span>
            <span :key="m.username + '_4'" v-else
              class="mdi mdi-radiobox-blank mdi-16px">
            </span>
          </template>
        </template>
      </div>
    </Form>
  </div>
</template>

<script>
import Form from './Form'
import Member from './nano/Member'
import Colors from '../common/Colors'
import { mapGetters } from 'vuex'

export default {
  name: 'Members',
  components: { Form, Member },
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
    memberIconStyle (member) {
      return {
        color: Colors[member.color].bg
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.members {
  display: grid;
  grid-template-columns: auto auto;
  span {
    margin: 0 3px;
  }
}
</style>
