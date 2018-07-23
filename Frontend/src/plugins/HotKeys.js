const HotKeysPlugin = {
  install (Vue) {
    let registeredHotkeys = new Set()
    let isEnabled = true
    Vue.prototype.$disableHotKeys = () => {
      isEnabled = false
    }
    Vue.prototype.$enableHotKeys = () => {
      isEnabled = true
    }
    Vue.mixin({
      mounted: function () {
        if (!Array.isArray(this.hotKeys)) {
          return
        }
        registeredHotkeys.add(this.hotKeys)
        this._hotKeysEvent = (e) => {
          console.log(e)
          this.hotKeys.forEach((key) => {
            if (!isEnabled && (key.code.startsWith('Key') || key.modalLock)) {
              return
            }
            if (!key.ctrl === e.ctrlKey) {
              return
            }
            if (!key.shift === key.shiftKey) {
              return
            }
            if (!key.alt === key.altKey) {
              return
            }
            if (e.code === key.code || (e.key === key.code && key.isKey)) {
              if (e.type === 'keyup' &&
                typeof key.method === 'function') {
                key.method(e)
              }
              if (e.type === 'keydown' &&
                typeof key.methodDown === 'function') {
                key.methodDown(e)
              }
              if (e.type === 'keypress' &&
                typeof key.methodPress === 'function') {
                key.methodPress(e)
              }
            }
          })
        }
        window.addEventListener('keyup', this._hotKeysEvent)
        window.addEventListener('keydown', this._hotKeysEvent)
        window.addEventListener('keypress', this._hotKeysEvent)
      },
      beforeDestroy: function () {
        registeredHotkeys.delete(this.hotKeys)
        window.removeEventListener('keyup', this._hotKeysEvent)
      }
    })
    let keyVal = key => {
      let modifiers = []
      if (key.ctrl) modifiers.push('Ctrl')
      if (key.alt) modifiers.push('Alt')
      if (key.shift) modifiers.push('Shift')
      modifiers.push(key.code.replace(/^Key/, ''))
      return modifiers.join('+')
    }
    Vue.prototype.$allHotKeys = () => {
      let resKeys = new Map()
      registeredHotkeys.forEach(el => {
        el.forEach(key => {
          if (!key.description) {
            return
          }
          let vals = resKeys.get(key.description) || new Set()
          vals.add(keyVal(key))
          resKeys.set(key.description, vals)
        })
      })
      return resKeys
    }
  }
}

export default HotKeysPlugin
