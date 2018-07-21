<template>
  <div @wheel="mousewheel" class="field" :class="labelClass + ' ' + statusClass">
    <div class="label" v-if="hasLabel">{{label}}</div>
    <input ref="inp" type="text" :maxlength="maxLength"
      :placeholder="placeholder" v-model="text"
      @keyup="onKey" @keydown="onKey" @keypress="onKey"
      @click="$event.target.select()">
    <div class="counter" v-show="text.length !== 0" v-if="hasCounter">
      {{text.length}}\{{max}}
    </div>
  </div>
</template>

<script>
const TYPE_TEXT = 'text'
const TYPE_NUMBER = 'number'
const ZERO_CHAR = '0'.charCodeAt(0)
const NINE_CHAR = '9'.charCodeAt(0)
const NUMPAD_ZERO_CHAR = ZERO_CHAR + 48
const NUMPAD_NINE_CHAR = NINE_CHAR + 48
const SPACE_CHAR = ' '.charCodeAt(0)
const LAST_SPECIAL_CODE = 46 // key 'del'

export default {
  name: 'field',
  props: {
    value: {
      type: [Number, String]
    },
    type: {
      type: String,
      default: TYPE_TEXT
    },
    label: {
      type: String,
      default: ''
    },
    validate: {
      type: String,
      default: ''
    },
    min: {
      type: Number,
      default: undefined
    },
    max: {
      type: Number,
      default: undefined
    },
    enableValidation: {
      type: Boolean,
      default: true
    },
    generator: {
      type: Function,
      default: undefined
    }
  },
  mounted () {
    if (this.validate !== '') {
      this._regExp = new RegExp(this.validate)
    } else if (this.type === TYPE_NUMBER) {
      this._regExp = new RegExp('^[+-]{0,1}[0-9]+$')
    }
    this.revalidate()
    this.placeholder = this.value + ''
  },
  data () {
    return {
      isLabelOut: false,
      statusClass: '',
      lastGenerated: '',
      placeholder: '',
      text: ''
    }
  },
  computed: {
    maxLength () {
      if (this.max !== undefined && this.type === TYPE_TEXT) {
        return this.max
      }
    },
    hasCounter () {
      return this.max !== undefined && this.type === TYPE_TEXT
    },
    hasLabel () {
      return this.label.length !== 0
    },
    labelClass () {
      return this.isLabelOut ? 'label-out' : ''
    }
  },
  methods: {
    onKey (e) {
      if (e.keyCode > LAST_SPECIAL_CODE || e.keyCode === SPACE_CHAR) {
        if (this.type === TYPE_NUMBER) {
          if (!((e.keyCode >= ZERO_CHAR && e.keyCode <= NINE_CHAR) ||
            (e.keyCode >= NUMPAD_ZERO_CHAR && e.keyCode <= NUMPAD_NINE_CHAR))) {
            e.preventDefault()
          }
        } else {
          e.stopPropagation()
        }
      }
    },
    focus () {
      this.$refs.inp.focus()
    },
    regenerate (force = false) {
      let canGenerate = this.generator !== undefined &&
        (this.lastGenerated === this.text || this.text === '')
      if (canGenerate || force) {
        let val = this.generator().next().value
        this.text = val
        this.lastGenerated = val
      }
    },
    mousewheel (event) {
      if (this.type === TYPE_NUMBER) {
        let val = parseInt(this.text)
        if (isNaN(val)) {
          this.text = parseInt(this.placeholder)
        } else {
          val -= event.deltaY / Math.abs(event.deltaY)
          if (val > this.max) {
            this.text = this.max + ''
          } else if (val < this.min) {
            this.text = this.min + ''
          } else {
            this.text = val + ''
          }
        }
      } else if (this.type === TYPE_TEXT) {
        this.regenerate()
      }
      event.preventDefault()
      return false
    },
    isValid () {
      if (!this.enableValidation) {
        return true
      }
      if (this._regExp !== undefined &&
        this._regExp.exec(this.text) === null) {
        return false
      }
      if (this.type === TYPE_NUMBER) {
        let val = parseInt(this.text)
        if (val < this.min) {
          return false
        }
        if (val > this.max) {
          return false
        }
      } else if (this.type === TYPE_TEXT &&
        this.text.length < this.min) {
        return false
      }
      return true
    },
    revalidate () {
      this.statusClass = ''
      if (this.isValid() && this.text.length !== 0) {
        this.statusClass = 'field-valid'
        return true
      }
      return false
    }
  },
  watch: {
    enableValidation () {
      this.$emit('change')
    },
    value (newValue) {
      let val = newValue
      if (this.type === TYPE_NUMBER) {
        if (!isNaN(parseInt(val))) {
          this.text = newValue + ''
        }
      }
    },
    text (newText) {
      this.isLabelOut = (newText + '').length !== 0
      if (this.type === TYPE_NUMBER) {
        this.$emit('input', parseInt(newText))
      } else {
        this.$emit('input', newText)
      }
      this.revalidate()
      this.$emit('change')
    },
    max () {
      this.revalidate()
    },
    min () {
      this.revalidate()
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../css/components/_text_input.scss';
</style>
