import * as types from './mutation_types';

export default {
  [types.SET_LIKED](state, liked) {
    Object.assign(state, { liked });
  },
};
