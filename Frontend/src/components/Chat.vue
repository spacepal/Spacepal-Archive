<template>
  <div class="chat">
    <div class="members">
      <p v-for="m in members" :key="m.id">
        <Member :id="m.id" />
      </p>
    </div>
    <div>

    </div>
  </div>
</template>

<script>
import Member from './nano/Member'
import { mapGetters } from 'vuex'

export default {
  name: 'Chat',
  components: {
    Member
  },
  computed: {
    ...mapGetters({
      members: 'members'
    })
  }
}
</script>

<style lang="scss" scoped>
.chat {
  display: flex;
}
.members > * {
  padding: 0;
  margin: 0;
}
.members {
  .member-username {
    display: none;
  }
  :hover .member-username {
    display: inline-block;
  }
}
</style>
