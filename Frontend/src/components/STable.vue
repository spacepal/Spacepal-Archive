<template>
  <div class="loop">
    <div :class="loadingClass">
      <table class="stable" cellspacing="5">
        <thead>
          <tr>
            <th v-for="field in fields" :key="field.name"
              v-html="field.name" :title='field.title' />
          </tr>
        </thead>
        <tbody>
          <tr v-if="rows.length === 0" class="norows">
            <td :colspan="fields.length">
              <slot name="notfound">There's no rows</slot>
            </td>
          </tr>
          <tr v-for="(row, i) in rows" :key="i" @click="rowClicked(row, i)">
            <td v-for="field in fields" :key="field.name">
              <span v-if="field.isBoolean === true">
                <span v-if="getKeyValue(row, field)"
                  class="mdi mdi-check mdi-24px"></span>
                <span v-else
                  class="mdi mdi-cancel mdi-24px"></span>
              </span>
              <span v-else>
                {{getKeyValue(row, field)}}
              </span>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
export default {
  name: 'STable',
  props: {
    fields: Array,
    rows: Array,
    loading: {
      type: Boolean,
      default: false
    }
  },
  data () {
    return {
    }
  },
  computed: {
    loadingClass () {
      return this.loading ? 'loading has-spinner' : 'has-spinner'
    }
  },
  methods: {
    getKeyValue (row, field) {
      if (field.key) {
        return row[field.key]
      } else if (field.value && typeof field.value === 'function') {
        return field.value(row)
      }
      console.warn('STable: No "key" or fucntion "value" in field')
      return ''
    },
    rowClicked (row, i) {
      if (!this.loading) {
        this.$emit('rowClicked', {row, i})
      }
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../css/components/_stable.scss';
</style>
