import Toast from '../components/Toast.vue'

const ToastPlugin = {
  install (Vue, options) {
    let toast = Toast
    let oldData = toast.data()
    toast.data = () => {
      let obj = {_Vue: Vue}
      Object.assign(obj, oldData)
      return obj
    }
    Vue.component(toast.name, toast)
    Vue.prototype.$toast = (msg, timeout) => {
      window.$toast(msg, timeout)
    }
  }
}

export default ToastPlugin
