<template>
  <div v-show="isVisible">
    <div class="help-panel-bg" @click.self="nextStage"></div>
    <div class="help-panel" v-if="isVisible" @click="nextStage" :class="cls">
      <div class="description">
        <p class="descr-line" v-for="d in descr" :key="d">{{ $t(d) }}</p>
        <p class="text-additional">
          <template v-if="currentStage === 0">
          {{ $t('Click anywhere for next tip') }}
          </template>
          <template v-else>
            {{ $t('Stage {stage} of {total}', {
              stage: currentStage + 1,
              total:  stages.length
            }) }}
          </template>
        </p>
      </div>
    </div>
  </div>
</template>

<script>
const hightlightClass = 'help-panel-el-highlighted'
export default {
  name: 'HelpPanel',
  props: {
    name: String,
    refs: Object,
    data: Object
  },
  data () {
    return {
      currentStage: 0,
      isVisible: false,
      hotKeys: [
        {
          code: 'Escape',
          isKey: true,
          method: () => {
            if (!this.isVisible) return
            this.done()
            return false
          }
        },
        {
          code: 'Space',
          method: this.nextStage
        },
        {
          code: 'ArrowDown',
          methodDown: this.prevStage
        },
        {
          code: 'ArrowUp',
          methodDown: this.nextStage
        },
        {
          code: 'ArrowLeft',
          methodDown: this.prevStage
        },
        {
          code: 'ArrowRight',
          methodDown: this.nextStage
        },
        {
          code: 'PageUp',
          method: this.nextStage
        },
        {
          code: 'PageDown',
          method: this.prevStage
        }
      ].map(el => {
        el.modalEnabled = true
        el.isKey = true
        el.en = this.enHotKeys
        return el
      }).concat({
        code: 'KeyL',
        method: this.show,
        description: this.$t('Show help'),
        isKey: true,
        en: () => !this.isVisible
      })
    }
  },
  computed: {
    stages () {
      return this.$store.getters['help/stages'][this.name]
    },
    stage () {
      return this.stages[this.currentStage] || {
        descr: () => [''],
        el: _ => undefined
      }
    },
    descr () {
      return this.stage.descr(this.data)
    },
    el () {
      return this.stage.el(this.refs)
    },
    cls () {
      return [
        this.stage.pos || 'center',
        this.stage.events !== false ? 'events' : ''
      ].join(' ')
    },
    stageHotKeys () {
      if (typeof this.stage.hotKeys === 'function') {
        return this.stage.hotKeys(this)
      }
    }
  },
  watch: {
    el (el) {
      if (el !== undefined) {
        this.$scrollTo(el)
      }
    }
  },
  mounted () {
    if (!this.$store.getters['help/done'](this.name)) {
      this.show()
    }
  },
  methods: {
    invisible () {
      this.isVisible = false
    },
    visible () {
      this.isVisible = true
    },
    enHotKeys () {
      return this.isVisible
    },
    show () {
      this.currentStage = -1
      this.isVisible = true
      this.nextStage()
      this.$disableHotKeys()
    },
    highlightEl () {
      if (this.el) {
        this.el.classList.add(hightlightClass)
      }
      if (this.stageHotKeys) {
        this.$registerHotKeys(this.stageHotKeys)
      }
    },
    unhighlightEl () {
      if (this.el) {
        this.el.classList.remove(hightlightClass)
      }
      if (this.stageHotKeys) {
        this.$unregisterHotKeys(this.stageHotKeys)
      }
    },
    prevStage () {
      this.unhighlightEl()
      if (this.currentStage > 0) {
        this.currentStage -= 2
        this.nextStage()
      }
    },
    done () {
      this.unhighlightEl()
      this.isVisible = false
      this.$store.dispatch('help/done', this.name)
      this.$enableHotKeys()
    },
    nextStage () {
      if (!this.isVisible) return
      this.unhighlightEl()
      this.currentStage++
      if (this.currentStage >= this.stages.length) {
        this.done()
        return
      }
      this.highlightEl()
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../css/components/_help_panel.scss';
</style>
