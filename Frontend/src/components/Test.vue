<template>
  <div class="game-page">
    <Map ref="map" full></Map>
    <div class="info-panel-bg" v-if="panelsVisibility.main">
      <Form class="info-panel-body">
        <Members class="withoutborder" />
        <GameInfo class="withoutborder" />
      </Form>
    </div>
    <div class="info-panel-bg" v-if="panelsVisibility.tasks">
      <Form class="info-panel-body">
        <Tasks @goToCell="goToCell"></Tasks>
      </Form>
    </div>
    <div class="info-panel-bg" v-if="panelsVisibility.notifications">
      <Form class="info-panel-body">
        <Notifications @goToCell="goToCell" />
      </Form>
    </div>
    <div class="menu">
      <span class="mdi mdi-menu mdi-36px"></span>
      <ActionButtons></ActionButtons>
    </div>
  </div>
</template>

<script>
import Faker from 'faker'
import Map from './Map'
import Form from './Form'
import GameInfo from './GameInfo'
import Members from './Members'
import ActionButtons from './ActionButtons'
import Notifications from './Notifications'
import Tasks from './Tasks'

export default {
  name: 'Play',
  components: {
    GameInfo,
    Map,
    Members,
    ActionButtons,
    Form,
    Notifications,
    Tasks
  },
  data () {
    let rnd = Faker.random.number({
      min: 3,
      max: 32
    })
    return {
      hotKeys: [
        {
          code: 'KeyQ',
          method: () => {
            this.panelsVisibility.main = false
          },
          methodDown: () => {
            this.hideAllPanels('info')
            this.panelsVisibility.main = true
          },
          description: 'Show game info'
        },
        {
          code: 'KeyT',
          method: () => {
            this.hideAllPanels('tasks')
            this.panelsVisibility.tasks ^= true
          },
          description: 'Show tasks'
        },
        {
          code: 'KeyN',
          method: () => {
            this.hideAllPanels('notifications')
            this.panelsVisibility.notifications ^= true
          },
          description: 'Show notifications'
        },
        {
          code: 'Space',
          method: this.endTurn,
          description: 'End turn'
        },
        {
          code: 'Escape',
          method: this.hideAllPanels
        }
      ],
      panelsVisibility: {
        main: false,
        tasks: false,
        notifications: false
      },
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
    this.$store.dispatch('login', 1)
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
          this.genEvents()
          this.$store.dispatch('unlock')
        }, 1000)
      }, 1000)
    }, 1000)
  },
  methods: {
    goToCell (cellID) {
      this.$refs.map.goToCell(cellID)
    },
    endTurn () {
      if (this.$store.getters.isLocked) {
        this.$toast('You cannot end turn now')
      } else {
        this.$store.dispatch('game/endTurn')
      }
    },
    hideAllPanels (except = '') {
      for (let k in this.panelsVisibility) {
        if (k === except) {
          continue
        }
        this.panelsVisibility[k] = false
      }
    },
    setLoggedIn () {
      this.$store.dispatch('login', Faker.random.number(1000))
    },
    genEvents () {
      let events = []
      for (let i = 1; i < 8; ++i) {
        events.push({
          type: 'PLANET_LOST',
          target: i,
          member: i
        })
      }
      this.$store.dispatch('events/set', events)
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
        state: 2
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

.menu::after {
  content: ''
}

$iconSize: 36px;
$padding: 4px;
$menuBtn: $iconSize + $padding * 2;
.menu {
  display: flex;
  align-items: center;
  position: fixed;
  top: 5px;
  right: 0;
  margin-right: $menuBtn;
  background: rgba(0, 0, 0, 0.7);
  color: white;
  border-radius: 0 0 0 10px;
  padding: $padding;
  height: 44px;
  transform: translateX(calc(100%));
  transition: transform 0.1s ease-in,
    height 0.1s ease-in;
}
.menu:hover {
  transform: translateX($menuBtn);
  height: 100px;
  transition: transform 0.1s ease-out,
    height 0.1s ease-out;
}
</style>
