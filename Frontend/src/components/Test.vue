<template>
  <div>
    <!-- <Map></Map> -->
    <div v-if="isLoggedIn" class='button' @click="logout">Logout</div>
    <div v-else class='button' @click="login">Login</div>
  </div>
</template>

<script>
import Map from './Map.vue'

export default {
  name: 'HelloWorld',
  components: {Map},
  data () {
    return {

    }
  },
  computed: {
    isLoggedIn () {
      return this.$store.getters.isPlayer
    }
  },
  methods: {
    login () {
      this.$store.dispatch('login', {
        username: 'hedhyw',
        gameID: '1',
        isCreator: true
      })
    },
    logout () {
      this.$store.dispatch('logout')
    }
  }
}
</script>

<style lang="scss">

</style>
