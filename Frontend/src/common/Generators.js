import Faker from 'faker'

export const UsernameGenerator = (function* () {
  while (true) {
    let username = Faker.name.firstName()
    if (username.length < 32 && username.length > 0) {
      yield username
    }
  }
})()

export const GameNameGenerator = (function* () {
  while (true) {
    let gamename = Faker.company.companyName()
    if (gamename.length < 32 && gamename.length > 0) {
      yield gamename
    }
  }
})()
