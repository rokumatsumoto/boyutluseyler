import * as types from './mutation_types';
// import {
//   USERNAME_FORM_GROUP_CLASS,
// } from '../constants';

export default {
  [types.DRAG_OVER](state) {
    state.hovering = true;
  },

  [types.DRAG_LEAVE](state) {
    state.hovering = false;
  },
};
