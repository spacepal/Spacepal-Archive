<template>
  <div id="app">
    <router-view/>
  </div>
</template>

<script>
export default {
  name: 'App'
}
</script>

<style lang="scss">
@import url('https://fonts.googleapis.com/css?family=Share+Tech+Mono');
@import 'mdi/css/materialdesignicons.min.css';
@import './css/_ui.scss';
#app {
  font-family: 'Share Tech Mono', monospace;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #4f7d92;
  margin-top: 60px;
}
</style>
