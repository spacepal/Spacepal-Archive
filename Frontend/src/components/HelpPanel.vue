<template>
  <div v-if="isVisible" @click.self="nextStage">
    <div class="help-panel-bg"></div>
    <div class="help-panel" v-if="isVisible" @click="nextStage" :class="pos">
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
    refs: Object
  },
  data () {
    return {
      currentStage: 0,
      isVisible: false,
      hotKeys: [
        {
          code: 'Escape',
          isKey: true,
          method: this.done
        },
        {
          code: 'Space',
          isKey: true,
          method: this.nextStage
        },
        {
          code: 'ArrowDown',
          isKey: true,
          methodDown: this.prevStage
        },
        {
          code: 'ArrowUp',
          isKey: true,
          methodDown: this.nextStage
        },
        {
          code: 'ArrowLeft',
          isKey: true,
          methodDown: this.prevStage
        },
        {
          code: 'ArrowRight',
          isKey: true,
          methodDown: this.nextStage
        },
        {
          code: 'PageUp',
          isKey: true,
          method: this.nextStage
        },
        {
          code: 'PageDown',
          isKey: true,
          method: this.prevStage
        }
      ]
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
      return this.stage.descr()
    },
    el () {
      return this.stage.el(this.refs)
    },
    pos () {
      return this.stage.pos || 'center'
    }
  },
  watch: {
    el (el) {
      this.$scrollTo(el)
    }
  },
  mounted () {
    this.currentStage = -1
    this.isVisible = !this.$store.getters['help/done'](this.name)
    this.nextStage()
    if (this.isVisible) {
      this.$disableHotKeys()
    }
  },
  methods: {
    highlightEl () {
      if (this.el) {
        this.el.classList.add(hightlightClass)
      }
    },
    unhighlightEl () {
      if (this.el) {
        this.el.classList.remove(hightlightClass)
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
