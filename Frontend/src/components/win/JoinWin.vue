<template>
  <div>
    <Window ref="confirm" type="confirm" @confirm="success"
      :title="$t('Confirm action')" :enabled="isValid">
      <template>
        {{ $t('Do you want to join game') }}<span v-if="!unknowGameID"> #{{ gameID }}</span>?
        <Form ref="joinForm" class="withoutborder">
          <TextInput :label="$t('Game ID')" v-model="gameID" ref="usernameInput"
            type="number" v-if="unknowGameID" :min="1" force
            @change="checkForm" />
          <TextInput :label="$t('Username')" v-model="username" ref="usernameInput"
            type="text" validate='^[0-9A-Za-z_-]*$' :min="1" :max="32" force
            @change="checkForm" :generator="generator" />
          <TextInput ref="pin" :label="$t('Pincode')" v-if="hasPinCode" v-model="pinCode"
            type="text" :min="4" :max="4" validate='^[0-9]+$'
            :enableValidation="hasPinCode" @change="checkForm" />
        </Form>
      </template>
      <template slot="footer">
        <div class="button" @click="setRandom">
          <span class="mdi mdi-dice-multiple mdi-24px"> </span>
        </div>
      </template>
    </Window>
  </div>
</template>

<script>
import Window from '../Window.vue'
import Form from '../Form.vue'
import TextInput from '../TextInput.vue'
import { UsernameGenerator } from '../../common/Generators.js'

export default {
  name: 'JoinWin',
  components: { Window, TextInput, Form },
  data () {
    return {
      gameID: undefined,
      username: undefined,
      pinCode: undefined,
      isValid: false,
      unknowGameID: false,
      hasPinCode: false
    }
  },
  methods: {
    generator () {
      return UsernameGenerator
    },
    setRandom () {
      this.$refs.usernameInput.regenerate(true)
    },
    show ({ gameID = undefined, username = '', hasPinCode = false }) {
      this.unknowGameID = gameID === undefined
      this.gameID = gameID
      this.pinCode = undefined
      this.hasPinCode = hasPinCode
      this.isValid = false
      this.username = username
      this.$refs.confirm.show()
      this.$nextTick(() => {
        if (username !== '' && hasPinCode) {
          this.$refs.pin.focus()
        }
      })
    },
    success () {
      this.$emit('join', {
        gameID: this.gameID,
        username: this.username,
        pinCode: this.pinCode,
        hasPinCode: this.hasPinCode
      })
    },
    checkForm () {
      this.isValid = this.$refs.joinForm.isValid()
    }
  }
}
</script>
