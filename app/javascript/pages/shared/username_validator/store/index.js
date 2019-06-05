import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex'
import mutations from './mutations'
import actions from './actions'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    available: false,
    valid: false,
    pending: false,
    empty: true,
    alreadyTaken: false
  },
  actions,
  mutations,
  strict: process.env.NODE_ENV !== 'production'
})
