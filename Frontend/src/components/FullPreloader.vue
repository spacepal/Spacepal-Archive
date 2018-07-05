<template>
  <div>
    <transition name="fade">
      <div class="background" v-if="isVisible">
        <div class="star" v-for="i in 300" :key="i" :style="rocketStyle(i, true)"></div>
        <div id="loading"></div>
      </div>
    </transition>
  </div>
</template>

<script>
export default {
  name: 'FullPreloader',
  data () {
    return {
      isVisible: false
    }
  },
  methods: {
    show () {
      this.isVisible = true
    },
    hide () {
      this.isVisible = false
    },
    rocketStyle (i) {
      let size = Math.random() + 1 + 'px'
      return {
        left: Math.random() * 100 + '%',
        top: Math.random() * 100 + '%',
        animationDuration: Math.random() * 30 + 2 + 's',
        width: size,
        height: size
      }
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../css/components/_preloader.scss';
</style>
