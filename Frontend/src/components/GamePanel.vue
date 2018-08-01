<template>
  <div class="info-panel-bg"
    v-show="isVisible"
    @click.self="hide" @click="onClick($event)">
    <Form class="info-panel-body">
      <slot></slot>
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
    empty: Boolean
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
