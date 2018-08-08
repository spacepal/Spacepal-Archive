<template>
  <div class="message-notify text-success" v-if="isVisible" @click="openChat">
    <span class="mdi mdi-36px mdi-message-alert-outline"></span>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'

export default {
  name: 'MessageNotify',
  computed: {
    ...mapGetters({ // @todo settings mute
      unread: 'chat/unread',
      panelGroups: 'panels/groups'
    }),
    chatIsOpened () {
      if (this.panelGroups[0]) {
        return this.panelGroups[0]['chat'] || false
      }
      return false
    },
    isVisible () {
      return this.unread && !this.chatIsOpened
    }
  },
  methods: {
    ...mapActions({
      showPanel: 'panels/show'
    }),
    openChat () {
      this.showPanel({
        group: 0,
        panel: 'chat'
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.message-notify {
  position: fixed;
  bottom: 2px;
  left: 2px;
  width: 50px;
  padding-top: 2px;
  box-sizing: content-box;
  height: 50px;
  border-radius: 100%;
  background: rgba(0, 0, 0, 0.4);
  display: flex;
  justify-content: center;
  align-items: center;
  > * {
    animation: notify 300ms linear alternate infinite;
  }
}
.message-notify:hover {
  background: rgba(0, 0, 0, 0.8);
}
@keyframes notify {
  from {
    opacity: 1.0;
  }
  to {
    opacity: 0.4;
  }
}
</style>
