import axios from 'axios'
import store from '@/store'

const service = {
  game: {
    status () {
      return axios.get(store.getters['backendAPI'] + 'games/status')
    },
    all (offset, limit) {
      return axios.get(store.getters['backendAPI'] + 'games', {
        params: {
          offset,
          limit
        }
      })
    },
    create (data) {
      return axios.post(store.getters['backendAPI'] + 'games',
        { data }, { withCredentials: true })
    },
    joinRandom (username) {
      return axios.put(store.getters['backendAPI'] + 'games/random/join',
        { data: { username } },
        { withCredentials: true })
    },
    join (gameID, pinCode, username) {
      return axios.put(store.getters['backendAPI'] + `games/${gameID}/join`, {
        data: {
          pinCode,
          username
        }
      }, { withCredentials: true })
    },
    logout (gameID) {
      return axios.delete(store.getters['backendAPI'] + `games/${gameID}/player`,
        { withCredentials: true })
    }
  }
}

export default service
