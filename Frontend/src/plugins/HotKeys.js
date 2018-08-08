let isEnabled = true
let registeredHotkeys = new Set()

function initListeners () {
  let _hotKeysEvent = (e) => {
    let en = isEnabled
    Array.from(registeredHotkeys.values()).some((keys) => {
      return keys.some((key) => {
        if (typeof key.en === 'function' && !key.en()) {
          return false
        }
        if (!(en || key.modalEnabled)) {
          return false
        }
        if (!key.ctrl === e.ctrlKey) {
          return false
        }
        if (!key.shift === key.shiftKey) {
          return false
        }
        if (!key.alt === key.altKey) {
          return false
        }
        if (e.code === key.code || (e.key === key.code && key.isKey)) {
          if (e.type === 'keyup' &&
            typeof key.method === 'function') {
            if (key.method(e) === false) return true
          }
          if (e.type === 'keydown' &&
            typeof key.methodDown === 'function') {
            if (key.methodDown(e) === false) return true
          }
          if (e.type === 'keypress' &&
            typeof key.methodPress === 'function') {
            if (key.methodPress(e) === false) return true
          }
        }
        return false
      })
    })
  }
  window.addEventListener('keyup', _hotKeysEvent)
  window.addEventListener('keydown', _hotKeysEvent)
  window.addEventListener('keypress', _hotKeysEvent)
}

const HotKeysPlugin = {
  install (Vue) {
    initListeners()
    Vue.prototype.$disableHotKeys = () => {
      isEnabled = false
    }
    Vue.prototype.$enableHotKeys = () => {
      isEnabled = true
    }
    Vue.prototype.$unregisterHotKeys = (hotKeys) => {
      registeredHotkeys.delete(hotKeys)
    }
    Vue.prototype.$registerHotKeys = (hotKeys) => {
      registeredHotkeys.add(hotKeys)
    }
    Vue.mixin({
      mounted: function () {
        if (!Array.isArray(this.hotKeys)) {
          return
        }
        registeredHotkeys.add(this.hotKeys)
      },
      beforeDestroy: function () {
        registeredHotkeys.delete(this.hotKeys)
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
