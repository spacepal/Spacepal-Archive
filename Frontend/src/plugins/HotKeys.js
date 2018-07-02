const HotKeysPlugin = {
  install (Vue) {
    Vue.mixin({
      mounted: function () {
        if (this.hotKeys === undefined) {
          return
        }
        this._hotKeysEvent = (e) => this.hotKeys[e.key]()
        window.addEventListener('keyup', this._hotKeysEvent)
      },
      beforeDestroy: function () {
        window.removeEventListener('keyup', this._hotKeysEvent)
      }
    })
  }
}

export default HotKeysPlugin
