<template>
  <div class="paginator">
    <div class="button" :class="previousClass" @click="go(-1)">Prev</div>
    <div class="page">{{currentPage + 1}} of {{lastPage}}</div>
    <div class="button" :class="nextClass" @click="go(+1)">Next</div>
  </div>
</template>

<script>
export default {
  props: {
    total: {
      type: Number,
      default: 1
    },
    limit: {
      type: Number,
      default: 30
    }
  },
  data () {
    return {
      currentPage: 0
    }
  },
  watch: {
    lastPage (lastPage) {
      if (this.currentPage !== 0 && this.currentPage >= lastPage) {
        this.set(lastPage - 1)
      }
    }
  },
  computed: {
    lastPage () {
      if (this.total === 0) {
        return 1
      }
      return Math.ceil(this.total / this.limit)
    },
    nextClass () {
      return (this.currentPage < this.lastPage - 1 ? '' : 'disabled')
    },
    previousClass () {
      return (this.currentPage > 0 ? '' : 'disabled')
    }
  },
  methods: {
    go (direction) {
      let page = this.currentPage + direction
      page = Math.max(0, page)
      page = Math.min(this.lastPage - 1, page)
      this.set(page)
    },
    set (page) {
      if (this.currentPage !== page) {
        this.$emit('pageChanged', {
          page: page,
          limit: this.limit,
          offset: page * this.limit
        })
        this.currentPage = page
      }
    }
  }
}
</script>

<style>
@import '../css/components/_paginator.scss';
</style>
