import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex'
import * as actions from './actions'
import mutations from './mutations'
import state from './state'


Vue.use(Vuex);

export default new Vuex.Store({
  actions,
  mutations,
  state: state(),
  strict: process.env.NODE_ENV !== 'production'
})
