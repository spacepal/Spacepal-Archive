<template>
  <div class="chat">
    <div class="block">
      <span v-if="messages.length === 0" class="empty text-additional">Empty</span>
      <div v-else class="body" ref="chatBody">
        <template v-for="(msg, i) in messages">
          <Member
            v-if="i === 0 || messages[i - 1].playerID !== msg.playerID"
            :id="msg.playerID" :key="i + '_1'" />
          <span v-else :key="i + '_1'"></span>
          <span :style="msg.style" :key="i + '_2'">{{ msg.text }}</span>
        </template>
        <span ref="chatBottom" class="chat-bottom"></span>
      </div>
      <div class="input flex-horizontal">
        <div class="recepient">
          <span class="mdi mdi-account-multiple mdi-16px current" v-if="recepient === -1">
            All
          </span>
          <span class="current" v-else>
            <Member :id="recepient" />
          </span>
          <div class="popup light-border">
            <p v-for="r in recepients" :key="r.id">
              <a @click="setRecepient(r.id)">
                <span class="mdi mdi-account-multiple mdi-16px current" v-if="r.id === -1">
                  All
                </span>
                <Member v-else :id="r.id" />
              </a>
            </p>
          </div>
        </div>
        <TextInput ref="msgInp" v-model="msg" force />
        <span @click="send"
          :class="sendBtnClass"
          class="button mdi mdi-send mdi-16px"
          :title="$t('send-message')"></span>
      </div>
    </div>
  </div>
</template>

<script>
import Member from './nano/Member'
import TextInput from './TextInput'
import { mapGetters, mapActions } from 'vuex'
// import Colors from '../common/Colors'

export default {
  name: 'Chat',
  data () {
    return {
      msg: '',
      recepient: -1,
      hotKeys: [
        {
          code: 'Enter',
          isKey: true,
          method: this.send,
          modalEnabled: true,
          en: () => this.isVisible
        },
        {
          code: 'Escape',
          isKey: true,
          method: this.close,
          modalEnabled: true,
          en: () => this.isVisible
        },
        {
          code: 'KeyC',
          method: this.close,
          modalEnabled: true,
          en: () => this.isVisible
        }
      ]
    }
  },
  components: {
    Member,
    TextInput
  },
  computed: {
    ...mapGetters({
      members: 'members',
      member: 'member',
      messages: 'chat/messages',
      panelGroups: 'panels/groups',
      profile: 'profile'
    }),
    recepients () {
      console.log(this.members)
      return Object.values(this.members).reduce((arr, m) => {
        if (m.id !== this.profile.id) {
          arr.push(m)
        }
        return arr
      }, [{
        id: -1
      }])
    },
    isVisible () {
      if (this.panelGroups[0]) {
        return this.panelGroups[0]['chat'] || false
      }
      return false
    },
    sendBtnClass () {
      return this.msg === '' ? 'disabled' : ''
    }
    // adoptedMessages () {
    //   return this.messages.map(msg => {
    //     let color = Colors['neutral'].bg
    //     let m = this.member(msg.playerID)
    //     if (m) {
    //       let tmp = Colors[m.color]
    //       if (tmp !== undefined) {
    //         color = tmp.bg
    //       }
    //     }
    //     msg.style = { color }
    //     return msg
    //   })
    // }
  },
  methods: {
    ...mapActions({
      sendMessage: 'chat/send',
      setRead: 'chat/setRead',
      hidePanel: 'panels/hide'
    }),
    send () {
      if (this.msg === '') {
        return
      }
      this.sendMessage({
        text: this.msg,
        recepientID: this.recepient
      })
      this.msg = ''
      this.$refs.msgInp.focus()
      this.scrollBottom()
    },
    close () {
      this.hidePanel({
        group: 0,
        panel: 'chat'
      })
    },
    setRecepient (playerID) {
      this.recepient = playerID
    },
    scrollBottom () {
      let container = this.$refs.chatBody
      let bottom = this.$refs.chatBottom
      if (container !== undefined && bottom !== undefined) {
        this.$scrollTo(bottom, 500, { container })
      }
    }
  },
  watch: {
    isVisible (val) {
      if (val) {
        this.$refs.msgInp.focus()
        this.$disableHotKeys()
        this.setRead()
        this.scrollBottom()
      } else {
        this.$enableHotKeys()
        this.setRead()
      }
    },
    messages () {
      this.scrollBottom()
    }
  }
}
</script>

<style lang="scss" scoped>
.chat {
  display: flex;
  .empty {
    display: flex;
    height: 180px;
    width: 100%;
    align-items: center;
    justify-content: center;
  }
  .body {
    display: grid;
    grid-template-columns: auto 300px;
    text-align: justify;
    min-height: 200px;
    max-height: 70vh;
    overflow-y: auto;
    padding: 8px;
  }
  .body > * {
    margin: 5px 3px;
  }
  .input {
    align-items: center;
  }
}
.popup {
  position: absolute;
  padding: 20px;
  background: rgba(0, 0, 0, 0.95);
  border-radius: 6px 6px 6px 0;
  display: flex;
  flex-direction: row;
}
.popup > * {
  white-space: nowrap
}
.recepient {
  user-select: none;
  position: relative;
  .popup {
    display: none
  }
  .current {
    text-align: center;
    margin: 0 5px;
    white-space: nowrap
  }
}
.recepient:hover .popup {
  display: block;
  bottom: 20px;
}
.chat-bottom {
  grid-column: 1 2;
}

</style>
