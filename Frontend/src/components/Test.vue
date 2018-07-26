<template>
  <div>
    <Form class="form">
      <Notifications></Notifications>
    </Form>
  </div>
</template>

<!--
  PLANET_LOST: 'The planet is lost',
  PLANET_SAVED: 'The planet is saved',
  ATTACK_FAILED: 'The attack is repelled',
  ATTACK_SUCCESS: 'The attack is succeeded',
  PIRATES_DAMAGED_PLANET: 'Damage by pirates',
  PIRATES_DAMAGED_FLEET: 'Damage by pirates',
  PLAYER_LOST: 'Player lost',
  FLEET_LAND: 'Fleet landed',
-->
<script>
import Notifications from './Notifications'
import Form from './Form'

export default {
  name: 'Test',
  components: {
    Notifications,
    Form
  },
  mounted () {
    this.$store.dispatch('setPlanets', [
      {
        id: 1,
        ownerID: 1,
        cellID: 1,
        production: 10,
        killPerc: 0.29,
        ships: 100,
        isCapital: true
      },
      {
        id: 2,
        ownerID: 2,
        cellID: 2,
        production: 20,
        killPerc: 0.31,
        ships: 120,
        isCapital: true
      }
    ])
    this.$store.dispatch('setMembers', [
      {
        id: 1,
        color: 1,
        username: 'username1',
        isArtificialIntelligence: false,
        artificialIntelligenceType: null,
        isEndTurn: false,
        isGameOver: false
      },
      {
        id: 2,
        color: 2,
        username: 'username2',
        isArtificialIntelligence: false,
        artificialIntelligenceType: null,
        isEndTurn: false,
        isGameOver: false
      },
      {
        id: 3,
        color: 3,
        username: 'username3',
        isArtificialIntelligence: false,
        artificialIntelligenceType: null,
        isEndTurn: true,
        isGameOver: true
      }
    ])
    setTimeout(() => {
      this.$store.dispatch('fleets/set', [
        {
          id: 13,
          from: 1,
          to: 2,
          count: 3,
          stepsLeft: 2
        }
      ])
    }, 10000)
    setTimeout(() => {
      this.$store.dispatch('events/set', [
        {
          type: 'PLANET_LOST',
          target: 2,
          member: 1
        },
        {
          type: 'PLANET_SAVED',
          target: 1,
          member: 1
        },
        {
          type: 'ATTACK_FAILED',
          target: 2,
          member: 1
        },
        {
          type: 'ATTACK_SUCCESS',
          target: 1,
          member: 1
        },
        {
          type: 'PIRATES_DAMAGED_PLANET',
          target: 1,
          member: 1
        },
        {
          type: 'PIRATES_DAMAGED_FLEET',
          target: 13,
          member: 1
        },
        {
          type: 'PLAYER_LOST',
          target: -1,
          member: 3
        },
        {
          type: 'FLEET_LAND',
          target: 2,
          member: 1
        }
      ])
    }, 3000)
  }
}
</script>

<style lang="scss" scoped>
.form {
  width: 480px;
}
</style>
