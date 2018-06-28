<template>
  <div class="hello">
    <div class="loop_header"></div>
    <div id="main">
      <STable></STable>
      <div class="button" @click="showWindow">Create game</div>
      <div class="button" @click="showToast">Open toast</div>
    </div>
    <Window ref="window" type="alert" title="Game creation">
      <div class="form">
        <TextInput placeholder="Username" validate='^[0-9A-Za-z_-]*$' :min="4" :max="32"></TextInput>
        <TextInput placeholder="Gamename" :max="48"></TextInput>
        <TextInput placeholder="Map width" type="number" defaultValue="24" :min="10" :max="1024"></TextInput>
        <TextInput placeholder="Map height" type="number" defaultValue="32" :min="10" :max="1024"></TextInput>
      </div>
    </Window>
    <Preloader ref="loader"></Preloader>
  </div>
</template>

<script>
import STable from './STable.vue'
import TextInput from './TextInput.vue'
import Preloader from './Preloader.vue'
import Window from './Window.vue'

export default {
  name: 'HelloWorld',
  components: {STable, Preloader, Window, TextInput},
  data () {
    return {
      msg: 'Welcome to Your Vue.js App'
    }
  },
  methods: {
    showWindow () {
      this.$refs.loader.show()
      setTimeout(() => {
        this.$refs.loader.hide()
        this.$refs.window.show()
      }, 3000)
    },
    showToast () {
      this.$toast('hello world')
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss">
#main {
  display: flex;
  justify-content: center;
  flex-direction: column;
  align-items: center;
}
</style>
