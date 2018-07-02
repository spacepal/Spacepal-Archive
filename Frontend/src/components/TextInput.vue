<template>
  <div @mousewheel="mousewheel" class="field" :class="labelClass + ' ' + statusClass">
    <div class="label" v-if="hasLabel">{{label}}</div>
    <input ref="inp" :type="type" :maxlength="maxLength" :min="minimum" :max="maximum"
      v-model="text" :placeholder="value" @focus="$event.target.select()">
    <div class="counter" v-show="text.length !== 0" v-if="hasCounter">
      {{text.length}}\{{max}}
    </div>
  </div>
</template>

<script>
const TYPE_TEXT = 'text'
const TYPE_NUMBER = 'number'

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
    }
  },
  mounted () {
    if (this.validate !== '') {
      this._regExp = new RegExp(this.validate)
    } else if (this.type === TYPE_NUMBER) {
      this._regExp = new RegExp('^[+-]{0,1}[0-9]+$')
    }
  },
  data () {
    return {
      text: '',
      isLabelOut: false,
      statusClass: ''
    }
  },
  computed: {
    minimum () {
      if (this.min !== undefined && this.type === TYPE_NUMBER) {
        return this.min
      }
    },
    maximum () {
      if (this.max !== undefined && this.type === TYPE_NUMBER) {
        return this.max
      }
    },
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
    focus () {
      this.$refs.inp.focus()
    },
    mousewheel (event) {
      if (this.type === TYPE_NUMBER) {
        if (this.text === '') {
          this.text = this.value
          return false
        }
        let val = this.text + event.wheelDelta / Math.abs(event.wheelDelta)
        if (val >= this.min && val <= this.max) {
          this.text = val
        }
        return false
      }
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
    text (newText) {
      this.isLabelOut = this.text.length !== 0
      if (this.revalidate()) {
        this.$emit('input', (this.type === TYPE_NUMBER ? parseInt(newText) : newText))
      }
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
