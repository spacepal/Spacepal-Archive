<template>
  <div class="field" :class="placeholderClass + ' ' + statusClass">
    <div class="label" v-if="hasLabel">{{placeholder}}</div>
    <input :type="type" :maxlength="maxLength" :min="minimum" :max="maximum"
      v-model="text" :placeholder="defaultValue" @focus="$event.target.select()">
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
    type: {
      type: String,
      default: TYPE_TEXT
    },
    defaultValue: {
      type: String,
      default: ''
    },
    placeholder: {
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
      isPlaceholderOut: false,
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
      return this.placeholder.length !== 0
    },
    placeholderClass () {
      return this.isPlaceholderOut ? 'label-out' : ''
    }
  },
  methods: {
    isValid () {
      if (this._regExp !== undefined &&
        this._regExp.exec(this.text) === null) {
        return false
      }
      if (this.type === TYPE_NUMBER) {
        let val = parseInt(this.text)
        if (this.min !== undefined && val < this.min) {
          return false
        }
        if (this.max !== undefined && val > this.max) {
          return false
        }
      } else if (this.type === TYPE_TEXT &&
        this.min !== undefined &&
        this.text.length < this.min) {
        return false
      }
      return true
    }
  },
  watch: {
    text (newText) {
      this.isPlaceholderOut = this.text.length !== 0
      this.statusClass = ''
      if (this.isValid()) {
        this.$emit('update:value', this.text)
        if (this.text.length !== 0) {
          this.statusClass = 'field-valid'
        }
      }
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../css/components/_text_input.scss';
</style>
