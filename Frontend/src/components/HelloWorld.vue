<template>
  <div class="hello">
    <div class="loop_header"></div>
    <div id="main">
      <STable></STable>
      <div class="button" @click="showWindow">Create game</div>
    </div>
    <Window ref="window" type="confirm" title="Game creation">
      <div class="form">
        <TextInput placeholder="Username" validate='^[0-9]{4,32}$' :max="32"></TextInput>
        <TextInput placeholder="Gamename" :max="48"></TextInput>
        <TextInput placeholder="Map width" validate='^[0-9]*$'></TextInput>
        <TextInput placeholder="Map height" validate='^[0-9]*$'></TextInput>
      </div>
    </Window>
    <Preloader ref="loader"></Preloader>
    <Toast></Toast>
  </div>
</template>

<script>
import STable from './STable.vue'
import TextInput from './TextInput.vue'
import Preloader from './Preloader.vue'
import Window from './Window.vue'
import Toast from './Toast.vue'

export default {
  name: 'HelloWorld',
  components: {STable, Preloader, Window, TextInput, Toast},
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
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style>
.i {
  width: 400px;
}
body {
  background: rgb(0, 0, 14);
}
#main {
  display: flex;
  justify-content: center;
  flex-direction: column;
  align-items: center;
}
@keyframes bg {
  from {
    background-position-x: 0%;
  }
  to {
    background-position-x: 150px;
  }
}
</style>
