
import { API_URL } from './constants.js'
import axios from 'axios'

const service = {
  game: {
    all (offset, limit) {
      return axios.get(API_URL + 'games', {
        params: {
          offset: offset,
          limit: limit
        }
      })
    },
    create (data) {
      return axios.post(API_URL + 'games', { data })
    },
    join (gameID, pinCode) {
      return axios.put(`${API_URL}games/${gameID}/join`, { data: { pinCode } })
    }
  }
}

export default service
