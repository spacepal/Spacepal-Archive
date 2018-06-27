<template>
  <div class="field"  :class="statusClass">
    <div class="label" v-if="placeholder.length !== 0"
      :class="placeholderClass">{{placeholder}}</div>
    <input type="text" :maxlength="max||65536"
      v-model="text">
    <div class="counter" v-show="text.length !== 0" v-if="max > 0">
      {{text.length}}\{{max}}
    </div>
  </div>
</template>

<script>
export default {
  name: 'field',
  props: {
    placeholder: {
      type: String,
      default: ''
    },
    validate: {
      type: String,
      default: ''
    },
    value: {
      type: String,
      default: ''
    },
    max: {
      type: Number,
      default: 0
    }
  },
  mounted () {
    if (this.validate !== '') {
      this._regExp = new RegExp(this.validate)
    }
  },
  data () {
    return {
      text: this.value,
      isPlaceholderOut: this.value.length > 0,
      statusClass: ''
    }
  },
  computed: {
    placeholderClass () {
      return this.isPlaceholderOut ? 'label-out' : ''
    }
  },
  methods: {
    isValid () {
      return this._regExp === undefined ||
        this._regExp.exec(this.text) !== null
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
