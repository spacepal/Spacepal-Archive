<template>
  <div>
    <Window ref="hotKeysWin" type="alert" :title="$t('Hotkeys')">
      <div class="hotKeysGrid">
        <template v-for="list in allHotKeys">
          <span :key="list[0] + '-description'">{{list[0]}}</span>
          <span :key="list[0] + '-icon'" class="mdi mdi-keyboard mdi-24px splitter"></span>
          <span :key="list[0] + '-hotkeys'">{{ Array.from(list[1]).join(', ') }}</span>
        </template>
      </div>
    </Window>
  </div>
</template>

<script>
import Window from '../Window'

export default {
  name: 'HotKeysWin',
  components: { Window },
  data () {
    return {
      allHotKeys: []
    }
  },
  methods: {
    show (allHotKeys) {
      this.allHotKeys = Array.from(allHotKeys)
      this.$refs.hotKeysWin.show()
    }
  }
}
</script>
