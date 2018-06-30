
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
    }
  }
}

export default service
