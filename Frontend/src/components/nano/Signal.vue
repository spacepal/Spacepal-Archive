<template>
  <div class="info-panel-bg signal" v-show="isVisible" :class="signalClass">
    <GameTitle mode="small no-signal-item"></GameTitle>
    <Form class="info-panel-body">
      <span class="signal-icon mdi mdi-16px text-highlighted" :class="icon"></span>
      {{message}}
    </Form>
    <a class="mdi mdi-github-circle no-signal-item"
      href="https://github.com/spacepal/Spacepal"> See on Github</a>
  </div>
</template>

<script>
import Service from '../../common/Service.js'
import GameTitle from './GameTitle'
import Form from '../Form'
const NO_SIGNAL_ICON = 'mdi-signal-off'
const SIGNAL_BAD_ICON = 'mdi-signal-cellular-1'
const SIGNAL_NORMAL_ICON = 'mdi-signal-cellular-2'
const SIGNAL_GOOD_ICON = 'mdi-signal-cellular-3'
const SIGNAL_UNKNOWN_ICON = 'mdi-signal-cellular-outline'
const SIGNAL_CHECK_INTERVAL = 3000
const MAX_CHECK_INTERVAL = 10000
const INC_CHECK_INTERVAL = 1000

export default {
  name: 'Signal',
  mounted () {
    let timerFunc = () => {
      this.checkConnection()
      setTimeout(timerFunc, this.lastCheckInterval)
      if (this.signalStrength === 0) {
        this.lastCheckInterval += INC_CHECK_INTERVAL
        this.lastCheckInterval = Math.min(MAX_CHECK_INTERVAL, this.lastCheckInterval)
      }
    }
    timerFunc()
  },
  components: {
    Form, GameTitle
  },
  data () {
    return {
      lastCheckInterval: SIGNAL_CHECK_INTERVAL,
      isShowed: false,
      signalStrength: -1
    }
  },
  computed: {
    signalClass () {
      return this.signalStrength === 0 ? 'no-signal' : ''
    },
    isVisible () {
      return this.isShowed || this.signalStrength === 0
    },
    icon () {
      if (this.signalStrength === 0) {
        return NO_SIGNAL_ICON
      } else if (this.signalStrength === 1) {
        return SIGNAL_BAD_ICON
      } else if (this.signalStrength === 2) {
        return SIGNAL_NORMAL_ICON
      } else if (this.signalStrength === 3) {
        return SIGNAL_GOOD_ICON
      }
      return SIGNAL_UNKNOWN_ICON
    },
    message () {
      if (this.signalStrength === 0) {
        return 'The server is unavailable'
      } else if (this.signalStrength === 1) {
        return 'Bad signal'
      } else if (this.signalStrength === 2) {
        return 'Normal signal'
      } else if (this.signalStrength === 3) {
        return 'Good signal'
      }
      return 'Loading...'
    }
  },
  methods: {
    show () {
      this.isShowed = true
    },
    hide () {
      this.isShowed = false
    },
    checkConnection () {
      let startTime = (new Date()).getTime()
      Service.game.status().then((r) => {
        let endTime = (new Date()).getTime()
        let score = 3 - Math.floor((endTime - startTime) / 20)
        score = Math.min(3, Math.max(1, score))
        this.signalStrength = score
      }).catch(() => {
        this.signalStrength = 0
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.signal {
  position: fixed;
  z-index: 10000000000;
  user-select: none;
  display: flex;
  flex-direction: column
}
.no-signal-item {
  display: none;
}
.no-signal {
  .no-signal-item {
    display: inline;
  }
  .signal-icon {
    animation: animBlink 0.6s linear infinite alternate !important;
  }
  background: black;
}
@keyframes animBlink {
  0% {
    opacity: 0.5;
  }
  100% {
    opacity: 1.0;
  }
}
</style>
