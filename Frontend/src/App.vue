<template>
  <div id="app" :class="theme">
    <div class="loop_header"></div>
    <transition name="fade">
      <router-view/>
    </transition>
    <Window ref="hotKeysWin" type="alert" title="Hotkeys">
      <div class="hotKeysGrid">
        <template v-for="list in Array.from(allHotKeys)">
          <span :key="list[0] + '-description'">{{list[0]}}</span>
          <span :key="list[0] + '-icon'" class="mdi mdi-keyboard mdi-24px splitter"></span>
          <span :key="list[0] + '-hotkeys'">{{Array.from(list[1]).join(', ')}}</span>
        </template>
      </div>
    </Window>
    <Toast glob />
  </div>
</template>

<script>
import Window from './components/Window.vue'
let themes = ['dark', 'light']
export default {
  name: 'App',
  data () {
    return {
      currentTheme: 0,
      hotKeys: [
        {
          code: 'Space',
          ctrl: true,
          method: () => {
            this.currentTheme = (this.currentTheme + 1) % themes.length
          },
          description: 'Change theme'
        },
        {
          code: 'Tab',
          alt: true,
          ctrl: true,
          method: () => {
            this.allHotKeys = this.$allHotKeys()
            this.$refs.hotKeysWin.show()
          },
          description: 'Show hotkeys'
        }
      ],
      allHotKeys: new Map()
    }
  },
  computed: {
    theme () {
      return themes[this.currentTheme]
    }
  },
  components: { Window }
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

.hotKeysGrid {
  display: grid;
  grid-template-columns: auto auto auto;
  .splitter {
    margin: 0 10px;
  }
}
</style>
