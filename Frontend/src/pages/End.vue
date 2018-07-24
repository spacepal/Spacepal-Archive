<template>
  <div id="end_page">
    <div>
      <template v-if="sync.members">
        <h1 v-if="isWinner">Congrulations!</h1>
        <h1 v-else>You lose...</h1>
      </template>
      <template v-else>
        <h1>
          Loading...
        </h1>
      </template>
      <Members class="members"></Members>
      <div class="button" @click="exit">Exit</div>
    </div>
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex'
import Members from '../components/Members'
import Form from '../components/Form'
export default {
  name: 'End',
  components: { Members, Form },
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

<style lang="scss" scoped>
#end_page {
  position: absolute;
  left: 0;
  top: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100%;
  min-width: 100%;
  text-align: center;
}
.members {
  text-align: left;
}
</style>
