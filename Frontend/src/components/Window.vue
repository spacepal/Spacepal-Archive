<template>
  <div>
    <div class="background full" v-if="isVisible"></div>
    <transition name="scale" mode="out-in">
      <div v-if="isVisible" class="full">
        <div id="window">
          <div id="title">
            <div class="loop_bg">
              {{title || 'No title'}}
            </div>
          </div>
          <div id="body">
            <p>
              <slot></slot>
            </p>
          </div>
          <div id="control">
            <template v-if="isConfirm">
              <div class="button">Confirm</div>
              <div class="button" @click="close">Cancel</div>
            </template>
            <template v-if="isAlert">
              <div class="button" @click="close">Ok</div>
            </template>
            <template slot="footer">

            </template>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
const TYPE_CONFIRM = 'confirm'
const TYPE_ALERT = 'alert'

export default {
  name: 'Window',
  props: {
    title: String,
    type: {
      type: String,
      default: TYPE_ALERT
    }
  },
  data () {
    return {
      isVisible: false,
      isConfirm: this.type === TYPE_CONFIRM,
      isAlert: this.type === TYPE_ALERT
    }
  },
  methods: {
    show () {
      this.isVisible = true
    },
    close () {
      this.isVisible = false
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../css/components/_window.scss';
</style>
