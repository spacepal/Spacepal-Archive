<template>
  <div>
    <Form class="members-info has-spinner" :class="loadingClass">
      <div class="members">
        <template v-for='i in 4' v-if="Object.keys(members).length === 0">
          <Member :key="i + '_1'" :id="-2"></Member>
          <span :key="i + '_2'" class="mdi mdi-radiobox-blank mdi-16px"></span>
          <span :key="i + '_3'"></span>
          <span :key="i + '_4'"></span>
        </template>
        <template v-for="m in members">
          <Member :key="m.username + '_1'" :id="m.id"></Member>
          <template v-if="!isRoom">
            <span :key="m.username + '_2'" v-if="m.isGameOver"></span>
            <template v-else>
              <span :key="m.username + '_2'" v-if='m.isEndTurn'
                class="mdi mdi-radiobox-marked mdi-16px">
              </span>
              <span :key="m.username + '_2'" v-else
                class="mdi mdi-radiobox-blank mdi-16px">
              </span>
            </template>
            <template>
              <span title="Total ships" class="mdi mdi-rocket mdi-16px">
                {{ m.currentFleetSize || 0 }}
              </span>
              <span title="Total production" class="mdi mdi-plus-box-outline mdi-16px">
                {{ m.currentProduction || 0 }}
              </span>
            </template>
          </template>
          <template v-else>
            <span :key="m.username + '_2'">
              <a v-if="m.isArtificialIntelligence && isCreator"
                class="mdi mdi-delete-forever"
                @click="delBot(m.id)"></a>
            </span>
            <span></span>
            <span></span>
          </template>
        </template>
        <template v-if="isRoom && isCreator && hasFreePlace">
          <a class="action" @click="addBot">
            Add bot
          </a>
          <span class="mdi mdi-desktop-classic"></span>
        </template>
      </div>
    </Form>
  </div>
</template>

<script>
import Form from './Form'
import Member from './nano/Member'
import Colors from '../common/Colors'
import { mapGetters, mapActions } from 'vuex'

export default {
  name: 'Members',
  components: { Form, Member },
  data () {
    return {
    }
  },
  computed: {
    ...mapGetters({
      members: 'members',
      sync: 'sync',
      isRoom: 'game/isRoom',
      hasFreePlace: 'game/hasFreePlace',
      isCreator: 'isCreator'
    }),
    loadingClass () {
      return this.sync.members ? '' : 'loading'
    }
  },
  methods: {
    ...mapActions({
      addBot: 'game/addBot',
      delBot: 'game/delBot'
    }),
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
  grid-template-columns: auto auto auto auto;
  span {
    margin: 0 3px;
  }
}
.action {
  text-align: center;
}
</style>
