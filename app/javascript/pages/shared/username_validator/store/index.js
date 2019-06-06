import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex'
import state from './state'
import mutations from './mutations'
import actions from './actions'

Vue.use(Vuex)

export default new Vuex.Store({
  state: state(),
  actions,
  mutations,
  strict: process.env.NODE_ENV !== 'production'
})
