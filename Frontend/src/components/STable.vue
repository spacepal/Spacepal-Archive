<template>
  <div>
    <div class="loop">
    <table class="stable" cellspacing="5">
      <thead>
        <th v-for="field in fields" :key="field">
          {{field}}
        </th>
      </thead>
      <tbody>
        <tr v-for="(row, i) in rows" :key="i">
          <td v-for="cell in row" :key="cell">
            {{cell}}
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
  data () {
    return {
      fields: ['id', 'name', 'creator', 'players', 'map'],
      rows: [
        [1, 'example', 'root', '0/8', '12x12'],
        [2, 'example', 'root', '0/8', '12x12'],
        [3, 'example', 'root', '0/8', '12x12'],
        [4, 'example', 'root', '0/8', '12x12']
      ]
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../css/components/_stable.scss';
</style>
