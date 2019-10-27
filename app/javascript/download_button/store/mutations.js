import * as types from './mutation_types';

export default {
  [types.SET_DOWNLOADING](state, isDownloading) {
    Object.assign(state, { isDownloading });
    console.log('isDownloading: ', state.isDownloading);
  },
};
