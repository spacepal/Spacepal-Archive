<template>
  <div class="chat">
    <div class="members">
      <p v-for="m in members" :key="m.id">
        <Member :id="m.id" />
      </p>
    </div>
    <div class="block">
      <div class="body">
        <template v-for="(msg, i) in messages">
          <Member
            v-if="i === 0 || messages[i - 1].playerID !== msg.playerID"
            :id="msg.playerID" :key="i + '_1'" />
          <span v-else :key="i + '_1'"></span>
          <span :style="msg.style" :key="i + '_2'">{{ msg.text }}</span>
        </template>
      </div>
      <div class="input flex-horizontal">
        <TextInput v-model="msg" force />
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
      msg: ''
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
      messages: 'chat/messages'
    }),
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
      sendMessage: 'chat/send'
    }),
    send () {
      if (this.msg === '') {
        return
      }
      this.sendMessage(this.msg)
      this.msg = ''
    }
  }
}
</script>

<style lang="scss">
.chat {
  display: flex;
  .body {
    display: grid;
    grid-template-columns: auto 300px;
    text-align: justify;
    max-height: 500px;
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
.members > * {
  padding: 0;
  margin: 0;
}
.members .member-username {
  display: none;
}
.members :hover .member-username {
  display: inline-block;
}
</style>
