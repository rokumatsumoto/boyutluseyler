import * as types from './mutation_types';

export default {
  [types.SET_DOWNLOADS_COUNT](state, downloadsCount) {
    Object.assign(state, { downloadsCount });
  },
};
