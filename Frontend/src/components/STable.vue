<template>
  <div>
    <div class="loop">
      <table class="stable" cellspacing="5">
        <thead>
          <tr>
            <th v-for="field in fields" :key="field.name" :title='field.title'>
              {{field.name}}
            </th>
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
              {{getKeyValue(row, field)}}
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
    rows: Array
  },
  data () {
    return {
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
      this.$emit('rowClicked', {row, i})
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../css/components/_stable.scss';
</style>
