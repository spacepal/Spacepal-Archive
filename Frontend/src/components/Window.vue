<template>
  <div>
    <div id="background" v-if="isVisible" class="full"></div>
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
@import '../css/_colors.scss';

.scale-enter-active, .scale-leave-active {
  transition: all .5s;
  opacity: 1.0;
  transform: scale3d(1.0, 1.0, 1.0);
}
.scale-enter, .scale-leave-to {
  opacity: 0;
  transform: scale3d(0.3, 0.3, 0.3);
  transition: all .5s;
}

#background {
  background: $opacityBackground;
}
.full {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: space-around;
  align-items: center;
}
#window {
  min-height: 250px;
  width: 400px;
  border: 2px solid $colorLight;
  display: flex;
  flex-direction: column;
  box-shadow: 0 0 6px $colorLight;
}
#title {
  margin: 7px;
  padding: 3px;
  width: calc(100% - 14px);
  box-sizing: border-box;
  color: $colorLight;
  border: 1px solid $colorLight;
}
#title div {
  padding: 9px;
}
#body {
  width: calc(100% - 14px);
  padding: 24px;
  margin: 0 7px;
  box-sizing: border-box;
  background: $opacityBackground;
  border: 1px solid $colorLight;
  flex: 1;
  display: flex;
  justify-content: center;
  align-items: center;
  overflow: auto;
}
#control {
  margin: 7px;
  min-height: 60px;
  display: flex;
  flex-direction: row;
  justify-content: center;
}

</style>
