<template>
  <transition name="toast">
    <div class="toast loop_bg" @click="close" v-if="isVisible">
      <div class="body">
        <p>
          {{text}}
        </p>
      </div>
    </div>
  </transition>
</template>

<script>
const DEFAULT_TIMEOUT = 3400

export default {
  name: 'Toast',
  data () {
    return {
      isVisible: false,
      text: ''
    }
  },
  props: {
    glob: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    show (msg, timeout = DEFAULT_TIMEOUT) {
      this._pending.push({
        message: msg,
        timeout: timeout
      })
      this.handle()
    },
    close () {
      clearTimeout(this._timeout)
      this.isVisible = false
      this.handle()
    },
    handle () {
      if (this._pending.length > 0 && !this.isVisible) {
        this.isVisible = true
        let el = this._pending.shift()
        this.text = el.message
        this._timeout = setTimeout(() => {
          this.close()
        }, el.timeout)
      }
    }
  },
  created () {
    this._pending = []
    if (this.glob) {
      window.$toast = this.show
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../css/components/_toast.scss';
</style>
