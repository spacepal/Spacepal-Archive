<template>
  <div>
    <div class="button" @click="go(-1)">Prev</div>
    {{currentPage + 1}}
    <div class="button" @click="go(+1)">Next</div>
  </div>
</template>

<script>
export default {
  props: {
    total: Number,
    limit: Number
  },
  data () {
    return {
      currentPage: 0
    }
  },
  computed: {
    lastPage () {
      return Math.ceil(this.total / this.limit)
    }
  },
  methods: {
    go (direction) {
      let page = this.currentPage + direction
      if (page < 0 || page > this.lastPage) {
        return
      }
      this.currentPage = page
      this.$emit('pageChanged', page)
    }
  }
}
</script>

<style>

</style>
