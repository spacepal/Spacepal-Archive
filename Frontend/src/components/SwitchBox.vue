<template>
  <label class="switch" :title="title">
    <p class="label-text">
      {{ label }}
    </p>
    <input type="checkbox" v-model="value" v-on:input="$emit('input', $event.target.checked)">
    <div class="slider"></div>
  </label>
</template>

<script>
export default {
  name: 'SwitchBox',
  props: {
    label: String,
    title: String,
    value: Boolean
  }
}
</script>

<style lang="scss" scoped>
@import '../css/components/_switch_box.scss';
</style>
