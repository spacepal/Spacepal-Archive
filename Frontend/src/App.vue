<template>
  <div id="app" :class="theme">
    <router-view/>
  </div>
</template>

<script>
let themes = ['dark', 'light']
export default {
  name: 'App',
  data () {
    return {
      currentTheme: 0
    }
  },
  computed: {
    theme () {
      return themes[this.currentTheme]
    }
  },
  mounted () {
    this._evt = (event) => {
      if (event.key === ' ') {
        this.currentTheme = (this.currentTheme + 1) % themes.length
      }
    }
    window.addEventListener('keyup', this._evt)
  },
  beforeDestroy () {
    window.removeEventListener('keyup', this._evt)
  }
}
</script>

<style lang="scss">
// @import url('https://fonts.googleapis.com/css?family=Share+Tech+Mono');
@import url('https://fonts.googleapis.com/css?family=Audiowide');
@import 'mdi/css/materialdesignicons.min.css';
@import './css/_ui.scss';
#app {
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
}
</style>
