<template>
  <div id="app" :class="theme">
    <div class="loop_header"></div>
    <transition name="fade">
      <router-view/>
    </transition>
    <Toast glob />
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
      if (event.key === ' ' && event.ctrlKey) {
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
  min-width: 100%;
  min-height: 100%;
}

.fade-enter-active, .fade-leave-active {
  transition-property: opacity;
  transition-duration: .25s;
}

.fade-enter-active {
  transition-delay: .25s;
}

.fade-enter, .fade-leave-active {
  opacity: 0
}
</style>
