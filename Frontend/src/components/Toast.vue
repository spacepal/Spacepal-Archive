<template>
  <div class="toast">
    <div class="body loop_bg">
      <p>
        Connection error<br>
        404 error
      </p>
    </div>
  </div>
</template>

<script>
export default {

}
</script>

<style lang="scss" scoped>
@import '../css/_colors.scss';

.toast {
  $width: 250px;
  position: fixed;
  width: $width;
  right: 30px;
  min-height: 100px;
  padding: 4px;
  bottom: 30px;
  margin-left: -$width * 0.5;
  box-sizing: border-box;
  display: flex;
  cursor: default;
  border: 1px solid $colorLight;
}
.toast .body {
  display: flex;
  justify-content: center;
  align-items: center;
  flex: 1;
  background: $gradientActive;
  color: white;
}
</style>
