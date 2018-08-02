<template>
  <div class="info-panel-bg"
    v-show="isVisible"
    @click.self="hide" @click="onClick($event)">
    <Form class="info-panel-body">
      <div class="flex-vertical form-block">
        <h2 v-if="title !== ''">{{title}}</h2>
        <div class="flex-horizontal">
          <slot></slot>
        </div>
      </div>
    </Form>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import Form from './Form'
export default {
  name: 'GamePanel',
  props: {
    group: Number,
    panel: String,
    empty: Boolean,
    title: {
      type: String,
      default: ''
    }
  },
  components: { Form },
  computed: {
    ...mapGetters({
      groups: 'panels/groups'
    }),
    isVisible () {
      let grp = this.groups[this.group]
      if (grp === undefined) {
        return false
      }
      return grp[this.panel] || false
    }
  },
  created () {
    this.register({
      group: this.group,
      panel: this.panel
    })
  },
  beforeDestroy () {
    this.unregister({
      group: this.group,
      panel: this.panel
    })
  },
  methods: {
    ...mapActions({
      hidePanel: 'panels/hide',
      showPanel: 'panels/show',
      register: 'panels/register',
      unregister: 'panels/unregister'
    }),
    hide () {
      this.hidePanel({
        group: this.group,
        panel: this.panel
      })
    },
    onClick (event) {
      if (this.empty) {
        this.hide()
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.info-panel-body .form-block {
  justify-content: center;
  align-items: center;
}
.form-block > h2 {
  font-weight: normal;
  font-size: 18pt;
}
</style>
