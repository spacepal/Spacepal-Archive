<template>
  <label class="switch" :title="title">
    <p class="label-text">
      {{ label }}
    </p>
    <input type="checkbox" v-model="checked" @input="emitEvents($event.target.checked)">
    <div @wheel="mousewheel" class="slider"></div>
  </label>
</template>

<script>
export default {
  name: 'SwitchBox',
  props: {
    label: String,
    title: String,
    value: Boolean
  },
  data () {
    return {
      checked: this.value
    }
  },
  watch: {
    value (newVal) {
      this.checked = newVal
      this.$emit('change')
    }
  },
  methods: {
    forceInput () {
      this.checked = this.value
    },
    mousewheel (e) {
      this.checked = e.deltaY < 0
      this.emitEvents(this.checked)
      e.preventDefault()
    },
    emitEvents (checked) {
      this.$emit('input', checked)
      this.$emit('change')
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../css/components/_switch_box.scss';
</style>
