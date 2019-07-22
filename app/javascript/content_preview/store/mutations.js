import * as types from './mutation_types';

export default {
  [types.REGISTER_CONTENT](state, content) {
    state.contents.push(content);
  },

  [types.SET_ACTIVE_CONTENT](state, content) {
    state.activeContent = content;
  },
};
