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
    rocketStyle (i, isStar) {
      let obj = {
        left: Math.random() * 100 + '%',
        top: Math.random() * 100 + '%',
        animationDuration: Math.random() * 30 + 2 + 's'
      }
      if (isStar) {
        obj.width = Math.random() + 1 + 'px'
        obj.height = obj.width
      } else {
        obj.opacity = Math.random() * 0.3 + 0.7
      }
      return obj
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../css/components/_preloader.scss';
</style>
