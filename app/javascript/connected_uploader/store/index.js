import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex';
import * as actions from './actions';
import * as getters from './getters';
import mutations from './mutations';
import state from './state';

Vue.use(Vuex);

export default function createStore() {
  return new Vuex.Store({
    actions,
    mutations,
    getters,
    state: state(),
    strict: process.env.NODE_ENV !== 'production',
  });
};
