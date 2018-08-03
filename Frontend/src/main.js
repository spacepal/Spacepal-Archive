// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import ToastPlugin from './plugins/Toast.js'
import HotKeysPlugin from './plugins/HotKeys.js'
import store from './store'
import vuexI18n from 'vuex-i18n'
// languages
import english from './resources/i18n/en.json'
import russian from './resources/i18n/ru.json'

Vue.use(vuexI18n.plugin, store)
Vue.use(ToastPlugin)
Vue.use(HotKeysPlugin)
Vue.config.productionTip = false
Vue.i18n.add('en', english)
Vue.i18n.add('ru', russian)
let lang = navigator.language || navigator.userLanguage
if (store.getters.savedLocale) {
  Vue.i18n.set(store.getters.savedLocale)
} else if (lang && Vue.i18n.localeExists(lang)) {
  Vue.i18n.set(lang)
} else {
  Vue.i18n.set('en')
}

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  store,
  components: { App },
  template: '<App/>'
})
