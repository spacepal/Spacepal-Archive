const HotKeysPlugin = {
  install (Vue, options) {
    let isCaseInsensitive = (
      options === undefined || options.caseInsensitive === undefined
        ? false : options.caseInsensitive)
    Vue.mixin({
      mounted: function () {
        if (!Array.isArray(this.hotKeys)) {
          return
        }
        this._hotKeysEvent = (e) => {
          this.hotKeys.forEach((key) => {
            if (!key.ctrl === e.ctrlKey) {
              return
            }
            if (!key.shift === key.shiftKey) {
              return
            }
            if (!key.alt === key.altKey) {
              return
            }
            let caseIns = (key.caseInsensitive !== undefined
              ? this.hotKeys.caseInsensitive : isCaseInsensitive)
            if (e.key === key.key || (caseIns &&
              e.key.toLowerCase() === key.key.toLowerCase())) {
              key.method(e)
            }
          })
        }
        window.addEventListener('keyup', this._hotKeysEvent)
      },
      beforeDestroy: function () {
        window.removeEventListener('keyup', this._hotKeysEvent)
      }
    })
  }
}

export default HotKeysPlugin
