
import { API_URL } from './constants.js'
import axios from 'axios'

const service = {
  game: {
    all (offset, limit) {
      return axios.get(API_URL + 'games', {
        params: {
          offset,
          limit
        }
      })
    },
    create (data) {
      return axios.post(API_URL + 'games', { data })
    },
    join (gameID, pinCode, username) {
      return axios.put(`${API_URL}games/${gameID}/join`, {
        data: {
          pinCode,
          username
        }
      })
    },
    logout (gameID) {
      return axios.delete(`${API_URL}games/${gameID}/player`)
    }
  }
}

export default service
