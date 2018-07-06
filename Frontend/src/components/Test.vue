<template>
  <div class="game-page">
    <Map full></Map>
    <!-- <div>
      <div class="button" @click="setLoggedIn">Set logged in</div>
      <ActionButtons></ActionButtons>
      <GameInfo />
      <Members />
    </div> -->
  </div>
</template>

<script>
import Faker from 'faker'
import Map from './Map'
import GameInfo from './GameInfo'
import Members from './Members'
import ActionButtons from './ActionButtons'

export default {
  name: 'HelloWorld',
  components: { GameInfo, Map, Members, ActionButtons },
  data () {
    let rnd = Faker.random.number({
      min: 3,
      max: 32
    })
    return {
      mapSizeWidth: Faker.random.number({
        min: rnd,
        max: 32
      }),
      mapSizeHeight: Faker.random.number({
        min: 3,
        max: 32
      })
    }
  },
  mounted () {
    this.$store.dispatch('unlock')
    this.$store.dispatch('setProfile', {
      id: 1,
      username: 'player1',
      isCreator: true,
      isEndTurn: false,
      isGameOver: false
    })
    setTimeout(() => {
      this.genGame()
      setTimeout(() => {
        this.genRandomPlanets()
        setTimeout(() => {
          this.genMembers()
        }, 1000)
      }, 1000)
    }, 1000)
  },
  methods: {
    setLoggedIn () {
      this.$store.dispatch('login', Faker.random.number(1000))
    },
    genGame () {
      this.$store.dispatch('game/setInfo', {
        id: Faker.random.number(100),
        name: Faker.company.companyName(),
        creator: 'Player1',
        pinCode: Faker.random.number({
          min: 1111,
          max: 9999
        }),
        mapWidth: this.mapSizeWidth,
        mapHeight: this.mapSizeHeight,
        planets: 100,
        buffs: Faker.random.boolean(),
        pirates: Faker.random.boolean(),
        accumulative: Faker.random.boolean(),
        productionAfterCapture: Faker.random.boolean(),
        turnNumber: 0,
        state: 1
      })
    },
    genRandomPlanets (count = 100) {
      let planets = []
      let ownerID = 1
      for (let i = 0; i < count; ++i) {
        planets.push({
          id: i,
          ownerID: (ownerID++) % 9,
          cellID: Faker.random.number({
            min: 0,
            max: this.mapSizeWidth * this.mapSizeHeight - 1
          }),
          killPerc: Math.random(),
          production: Faker.random.number({
            min: 10,
            max: 80
          }),
          ships: Faker.random.number({
            min: 0,
            max: 1000
          })
        })
      }
      this.$store.dispatch('setPlanets', planets)
    },
    genMembers () {
      let members = []
      for (let i = 1; i < 9; ++i) {
        members.push({
          id: i,
          color: i,
          username: 'player' + i,
          isArtificialIntelligence: Faker.random.boolean(),
          artificialIntelligenceType: Faker.random.number(10),
          isEndTurn: Faker.random.boolean(),
          isGameOver: Faker.random.boolean()
        })
      }
      this.$store.dispatch('setMembers', members)
    }
  }
}
</script>

<style lang="scss">
.room-page {
  display: grid;
  grid-template-columns: auto 300px;
}
.map-field {
  $margin: 10px;
  max-width: calc(100% - #{$margin});
  max-height: calc(100% - #{$margin});
  display: flex;
  justify-content: center;
  align-items: center;
  margin: $margin;
}
</style>
