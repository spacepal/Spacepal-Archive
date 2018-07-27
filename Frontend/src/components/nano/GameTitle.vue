<template>
  <div :class="mode" class="game-title">Space<sup>Pal</sup></div>
</template>

<script>
export default {
  name: 'GameTitle',
  props: {
    mode: {
      type: String,
      default: ''
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../../css/components/_game_title.scss';
</style>
