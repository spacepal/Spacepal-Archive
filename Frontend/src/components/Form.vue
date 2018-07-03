<template>
  <div class="form">
    <slot></slot>
  </div>
</template>

<script>
export default {
  name: 'Form',
  mounted () {
    this.$children.some(ref => {
      if (typeof ref.focus === 'function') {
        ref.focus()
        return true
      }
      return false
    })
  },
  methods: {
    isValid () {
      return !this.$children.some(ref => {
        if (typeof ref.isValid === 'function') {
          return !ref.isValid()
        }
        return false
      })
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../css/components/_form.scss';
</style>
