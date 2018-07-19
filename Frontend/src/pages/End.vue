<template>
  <div>
    <template v-if="sync.members">
      <h1 v-if="isWinner">Congrulations!</h1>
      <h1 v-else>You lose...</h1>
    </template>
    <template v-else>
      Loading...
    </template>
    <Members></Members>
    <div class="button" @click="exit">Exit</div>
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex'
import Members from '../components/Members'
export default {
  name: 'End',
  components: { Members },
  methods: {
    ...mapActions(['logout']),
    exit () {
      this.logout()
      this.$router.push({ name: 'GamesList' })
    }
  },
  computed: {
    ...mapGetters(['isWinner', 'sync'])
  }
}
</script>
